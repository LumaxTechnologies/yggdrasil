"""Console script for yggdrasil."""
import os
import sys
import click

from yggdrasil.init import (
    folder,
    config_gitops,
    set_ssh_keys,
    configure_ip,
    prepare_scope_folder,
    set_mode,
    set_admin,
    set_dns,
    delete_dns,
    init_meta_aggregate,
    init_meta_distribute
)
from yggdrasil.ans import (
    install_ansible_playbooks,
    install_ansible_dependencies,
    install_ansible_roles,
    load_ssh_parameters,
    load_ssh_parameters_meta,
    create_inventory,
    setup_ssh_connection,
    prepare_ansible,
    execute_ansible,
    meta_distribute,
    meta_aggregate
)
from yggdrasil.yggdrasil import Operation
from yggdrasil.common_tools import create_logger
from yggdrasil.data import allowed_actions, available_api_services, non_scope_init_actions
from yggdrasil.service import tf_service_generic, prepare, convert
from yggdrasil.tf import tf_generic
from yggdrasil.admin import gather, dns, vms, monitoring, subnets, clusters
from yggdrasil.config import generate, deploy

CONTEXT_SETTINGS = dict(help_option_names=['-h', '--help'])

@click.group(context_settings=CONTEXT_SETTINGS)
@click.version_option()
@click.option('--project-root', '-p', default='.', help="set the gitops project root")
@click.option('--libraries-path', '-l', default=None,
              help="set a custom folder of libraries for Terraform modules and Ansible playbooks")
@click.option('--output-file', '-o', default=None,
              help="define a file path for dumping outputs of Yggdrasil")
@click.option('--error-file', '-e', default=None,
              help="define a file path for dumping erros of Yggdrasil")
@click.option('--recursive', '-r', is_flag=True, default=False,
              help="this option will apply your command recursively on all scope folders inside"
              "current folder")
@click.option('--verbose', '-v', is_flag=True, default=False,
              help="set logger to verbose mode")
@click.argument('scope')
@click.pass_context
def main(context, scope, project_root, libraries_path, output_file, error_file, recursive, verbose):
    """ Yggdrasil is a CLI tool for creating, configuring and managing infrastructures.
    """

    # create a logger for the command
    logger = create_logger(verbose=verbose)

    logger.info("Starting Yggdrasil")

    # check consistency of arguments
    project_root = os.path.expanduser(project_root)
    if not os.path.isdir(project_root):
        logger.error("The folder %s for project root does not exist" % project_root)
        sys.exit("Impossible to go on")

    # let us define the scope or list of scopes, and the list of operations
    scopes = []
    operations = []

    # if the scope is not the 'root' folder and the last element of the scope
    # is a path separator, we remove it
    if len(scope) > 1:
        if scope[-1] == os.sep:
            scope = scope[:-1]

    scope_elts = scope.split(os.sep)
    # if the first folder of scope is NOT 'config', we add it to the scope path
    # - this behavior is meant to facilitate autocompletion on scope path
    if scope_elts[0] != "config":
        logger.debug("Adding 'config' to scope(s) path")
        scope = os.path.join("config", scope)
        logger.debug("New scope path is %s" % scope)

    # if 'recursive' option is set, we detect all scopes contained in subfolders
    # of current working directory

    if recursive:
        for root, _, files in os.walk(os.path.join(project_root, scope)):
            for file in files:
                if file == "config.yml":
                    subscope = root.lstrip('./').rstrip('/')
                    logger.info(
                        "Will execute Yggdrasil action on subscope %s" % subscope)
                    scopes.append(subscope)

        # otherwise, we consider the current working directory as a simple scope
    else:
        logger.info("Starting Yggdrasil action on simple scope %s", scope)
        scopes = [scope]

    for scope_elt in scopes:
        operation = Operation(logger, project_root, scope_elt, libraries_path, output_file,
                              error_file)
        # let us check if the provided scope is a well-configured scope in a well-configured
        # project folder
        # if not the case, we should assume that we are using a `init folder` or `init config`
        # command
        root_dotenv = os.path.join(project_root, ".env")
        config_file = os.path.join(project_root, scope_elt, "config.yml")
        meta_config_file = os.path.join(project_root, scope_elt, "meta_config.yml")
        deploy_config_file = os.path.join(project_root, scope_elt, "deploy.yml")
        if (os.path.exists(config_file)|os.path.exists(meta_config_file)):
            operation.scope_setup()
            operation.secrets_setup()
            operation.logger.debug("Operations setup")
        else :
            operation.logger.info("Working on empty scope")
            operation.empty_scope = True

        operations.append(operation)

    # necessary to pass main CLI context to sub actions
    context.obj = {
        "operations": operations
    }

    return


@click.command('init', short_help='init actions')
@click.argument('action')
@click.argument('action_argument', default=None, required=False)
@click.option('--ptr',
              is_flag=True,
              default=False,
              help="add PTR records to DNS A records")
@click.pass_context
def init(context, action, action_argument, ptr):
    """ Initial actions for preparing a new scope :
\n- folder (F)            : create a boostrap gitops folder
\n- config_gitops (C)     : configure current gitops folder
\n- ssh_keys (0)          : create a dedicated pair of SSH keys
for the current scope in secrets/ssh/<PROVIDER>/private|public
\n- get_ip (1)            : collect available IPs from fping
\n- scope_folder (2)      : prepare scope folder
\n- set_admin (3)         : prepare list of admin users for the VMs
\n- set_mode (4)          : update config.yml to associate specification mode (HA, low, ...) to vm parameters
\n- set_dns (5)           : create DNS records according to config_ips.yml
\n- delete_dns (6)        : delete DNS records according to config_ips.yml
\n- meta_aggregate (M1)   : aggregate config.yml files from children scopes
\n- meta_distribute (M2)  : distribute the meta_config.yml to children scopes
\n- consolidate (C)       : consolidate addresses and networks from cluster
    """

    for operation_context in context.obj['operations']:
        operation: Operation = operation_context

        # check if action is allowed
        action_alias = allowed_actions["init"].get(action, "NONE")
        if action_alias != "NONE":

            operation.logger.debug("%s command" % action_alias)

        else:
            # unallowed action
            operation.logger.error("Unallowed action %s" % action)
            sys.exit()

        # do we add PTR records to A records ?
        if ptr:
            operation.ptr = True

        if operation.empty_scope & (action_alias not in non_scope_init_actions):
            operation.logger.debug("Empty scope %s, skipping operation"
                                  % operation.scope)
            continue

        operation.logger.info("init action on scope %s" % operation.scope)

        if action_argument:
            globals()[action_alias](operation, action_argument)
        else:
            globals()[action_alias](operation)

    operation.logger.info("Finished init action sucessfully")


@click.command('tf', short_help='Terraform actions')
@click.argument('action')
@click.option('--nolock', '-nl', is_flag=True, default=False,
              help="use Terraform with the '-lock=false' flag")
@click.option('--reconfigure', is_flag=True, default=False,
              help="use Terraform init with the '-reconfigure' flag")
@click.pass_context
def tf(context, action, nolock, reconfigure):
    """ Terraform actions
\n- init (1)             : run Terraform init
\n- apply (2)            : run Terraform apply & output
\n- output (O)           : run Terraform output
\n- import (I)           : custom command for cleaning current tfstate
from declared resources and reimporting them
\n- refresh (R)          : run Terraform refresh & output
\n- destroy (D)          : run Terraform destroy
    """

    for operation_context in context.obj['operations']:
        operation: Operation = operation_context

        if operation.empty_scope :
            operation.logger.info("Empty scope %s, skipping operation"
                                  % operation.scope)
            continue

        operation.logger.debug("tf action on scope %s" % operation.scope)

        # do we apply no-lock flag ?
        if nolock:
            operation.tf_no_lock = True

        # do we apply reconfigure flag ?
        if reconfigure:
            operation.tf_reconfigure = True

        # check if action is allowed
        if action in allowed_actions["tf"].keys():

            operation.logger.debug("%s command" % allowed_actions["tf"][action])
            tf_generic(operation, allowed_actions["tf"][action])

        else:
            # unallowed action
            operation.logger.error("Unallowed action %s" % action)
            sys.exit()

    operation.logger.info("Finished tf action sucessfully")


@click.command('ans', short_help='Ansible actions')
@click.argument('action')
@click.option('--consolidated', '-c',
              is_flag=True,
              default=False,
              help="running the ansible command in the 'meta' folder")
@click.option('--default-user', '-d',
              is_flag=True,
              default=False,
              help="will execute ssh connexion using the default user of the VM")
@click.option('--restricted-vms', '-r',
              default=None,
              help="restrict ansible command to hosts listed")
@click.option('--ansible-force-install', '-F',
              is_flag=True,
              default=False)
@click.option('--port', '-P',
              default='22',
              help="set a different port for SSH connexion than the default one (22)")
@click.option('--default-ssh-port', '-dsp',
              is_flag=True,
              default=False,
              help="keep default SSH port (22) for current operation")
@click.option('--no-check', '-nc',
              is_flag=True,
              default=False,
              help="disable fingerprint check at SSH connection")
@click.option('--ssh-password', '-k',
              is_flag=True,
              default=False,
              help="use password for SSH connexion (default False)")
@click.option('--obsolete-ssh', '-o',
              is_flag=True,
              default=False,
              help="allow insecure SSH encryption algorithm for obsolete remote hosts (warning : security issue)")
@click.option('--encrypted-file', '-e',
              default=None,
              help="name of encrypted file in 'secrets/ansible-vault' to load at execution time")
@click.option('--ansible-key', '-a',
              default='ansible',
              help="name of the ansible key to use in config.yml")
@click.pass_context
def ans(context, action, consolidated, default_user, restricted_vms,
        ansible_force_install, port, default_ssh_port, no_check, ssh_password, obsolete_ssh,
        encrypted_file, ansible_key):
    """ Ansible actions
\n- securize (Z)         : set defined users, deactivate default user
\n- setup (S)            : configure basic sysadmin features
\n- playbooks (P)        : install Ansible playbooks catalog
\n- roles (R)            : install Ansible roles catalog
\n- dependencies (D)     : install Ansible dependencies (roles)
\n- inventory (1)        : prepare Ansible inventory
\n- prep_ansible (2)     : prepare Ansible meta-playbook
\n- setup_ssh (H)        : initialize SSH connections
\n- run_ansible (3)      : run Ansible meta-playbook
"""

    for operation_context in context.obj['operations']:
        operation: Operation = operation_context

        if operation.empty_scope :
            operation.logger.info("Empty scope %s, skipping operation"
                                  % operation.scope)
            continue

        operation.set_ansible_options(
            consolidated,
            default_user,
            ansible_force_install,
            restricted_vms,
            port,
            no_check,
            ssh_password,
            obsolete_ssh,
            encrypted_file,
            ansible_key
        )

        operation.logger.info("ansible action %s on scope %s" % (action, operation.scope))

        if operation.restricted_vms:
            operation.set_restricted_vms()

        if action in allowed_actions["ans"].keys():
            operation.logger.debug("%s command" %
                                   allowed_actions["ans"][action])
            # if the action chosen is 'securize', we keep default ssh port
            if allowed_actions["ans"][action] == "securize":
                default_ssh_port = True

            # we load the SSH config parameters
            if allowed_actions["ans"][action] != "meta_distribute":
                operation.set_terraform_output_info()
                if not operation.consolidated:
                    load_ssh_parameters(operation, keep_default_ssh=default_ssh_port)
                else:
                    load_ssh_parameters_meta(operation, keep_default_ssh=default_ssh_port)

            # if the action chosen is 'securize', it means we roll
            # 'devops init' role after ans 1 --d, ans 2 --d
            if allowed_actions["ans"][action] == "securize":
                operation.default_user = True
                operation.devops_init()
                create_inventory(operation)
                setup_ssh_connection(operation)
                prepare_ansible(operation, securize=True)
                execute_ansible(operation)
                return

            # if the action chosen is 'setup', it means we roll
            # 'devops-securize' role after ans 1, ans 2
            if allowed_actions["ans"][action] == "setup":
                operation.ssh_no_check = True
                operation.devops_setup()
                create_inventory(operation)
                setup_ssh_connection(operation)
                prepare_ansible(operation, securize=True)
                execute_ansible(operation)
                return

            # if the action chosen is 'firewall', it means we roll
            # a specifically generated playbook after ans 1, ans 2
            if allowed_actions["ans"][action] == "setup":
                operation.ssh_no_check = True
                operation.devops_firewall_check()
                create_inventory(operation)
                setup_ssh_connection(operation)
                prepare_ansible(operation, securize=True)
                execute_ansible(operation)
                return

            globals()[allowed_actions["ans"][action]](operation)

        else:
            operation.logger.error("Unallowed action %s" % action)
            sys.exit()

    operation.logger.info("Finished ansible action sucessfully")


@click.command('service', short_help='service configuration')
@click.argument('name')
@click.argument('step')
@click.option('--src-path', '-src',
              default='.',
              help="path to service configuration file")
@click.pass_context
def service(context, name, step, src_path):
    """ Service configuration through Terraform
\nservice names:
\n- gitlab                : configure Gitlab
\n- nexus                 : configure Nexus
\nsteps :
\n- prepare (0)           : prepare associated Terraform folder and module
\n- init (1)              : run Terraform init
\n- apply (2)             : run Terraform apply & output
\n- refresh (R)           : run Terraform refresh & output
\n- convert (C)           : service configuration file to yggdrasil format
\n- destroy (D)           : run Terraform destroy
    """

    for operation_context in context.obj['operations']:
        operation: Operation = operation_context

        if operation.empty_scope :
            operation.logger.info("Empty scope %s, skipping operation"
                                  % operation.scope)
            continue

        operation.logger.info("service action")

        # check if service exists and is well defined
        if name not in operation.scope_config_dict.keys():
            operation.logger.error("Warning : the requested service is "
                                   "not defined in the config.yml file. Exiting")
            sys.exit()

        if name not in available_api_services:
            operation.logger.error("Warning : the requested service is "
                                   "not available in Yggdrasil. Exiting")
            sys.exit()

        if step in allowed_actions["service"].keys():

            operation.logger.debug("%s command" %
                                   allowed_actions["service"][step])

            if allowed_actions["service"][step] == "prepare":
                prepare(operation, name)
            elif allowed_actions["service"][step] == "convert":
                convert(operation, name, src_path)
            else:
                tf_service_generic(operation, allowed_actions["service"][step], name)

        else:
            operation.logger.error("Unallowed service %s" % name)
            sys.exit()

    operation.logger.info("Finished service action sucessfully")


@click.command('admin', short_help='admin actions')
@click.argument('action')
@click.option('--domain',
              default='internal',
              help="domain for DNS check")
@click.option('--timestamp',
              default='',
              help="timestamp of metadata file")
@click.option('--all-vms', '-a',
              is_flag=True,
              default=False,
              help="run admin commands on all available VMs")
@click.option('--check-existence',
              is_flag=True,
              default=False,
              help="consider only VMs that exists in 'all_existing_vms.yml'")
@click.pass_context
def admin(context, action, domain, timestamp, all_vms, check_existence):
    """ Admin actions for managing a whole cluster or account :
\n- gather (G)            : gather all config files from subfolders into a meta folder
\n- dns (D)               : check DNS associated with all VMs from meta folder
\n- vms (V)               : list all VMs from virtualizer and compare with meta folder
\n- subnets (S)           : list all subnets from virtualizer and compare with meta folder
\n- monitoring (M)        : prepare Grafana configuration files from metadata file
    """

    for operation_context in context.obj['operations']:
        operation: Operation = operation_context

        operation.logger.info("admin action on folder %s" % operation.scope)

        # check if action is allowed
        if action in allowed_actions["admin"].keys():

            operation.logger.debug("%s command" %
                                   allowed_actions["admin"][action])
            operation.scope_setup()
            operation.set_domain(domain)
            operation.set_timestamp(timestamp)
            operation.set_vms(all_vms)
            operation.set_check_existence(check_existence)

            # if we are working with a meta scope, we load meta information
            if operation.meta_scope:
                operation.logger.info("Loading current meta information")
                operation.load_meta_info()

            globals()[allowed_actions["admin"][action]](operation)

        else:
            # unallowed action
            operation.logger.error("Unallowed action %s" % action)
            sys.exit()

    operation.logger.info("Finished admin action sucessfully")

@click.command('config', short_help='config actions')
@click.argument('action')
@click.option('--platform', '-p',
              is_flag=True,
              default=False,
              help="set a full platform from a manifest file")
@click.pass_context
def config(context, action, platform):
    """ Config actions for generating a new scope and a new config.yml :
\n- generate (G)            : generate a scope and a config file
\n- deploy (D)              : finalize config file when creating a platform

--platform/-p               : set a full platform from a manifest file
    """

    for operation_context in context.obj['operations']:
        operation: Operation = operation_context

        operation.logger.info("config action on folder %s" % operation.scope)

        # check if action is allowed
        if action in allowed_actions["config"].keys():

            operation.logger.debug("%s command" %
                                   allowed_actions["config"][action])
            if allowed_actions["config"][action] != "deploy":
                operation.scope_setup()

                # we activate the use of a manifest if necessary
                operation.set_manifest(platform)

                # we need to load meta information
                operation.logger.info("Loading current meta information")
                operation.load_meta_info()

            else:
                operation.scope_setup(no_config=True)

            globals()[allowed_actions["config"][action]](operation)

        else:
            # unallowed action
            operation.logger.error("Unallowed action %s" % action)
            sys.exit()

    operation.logger.info("Finished config action sucessfully")

main.add_command(init)
main.add_command(tf)
main.add_command(ans)
main.add_command(service)
main.add_command(admin)
main.add_command(config)

if __name__ == "__main__":
    main()

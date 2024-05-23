# CLI documentation

- [CLI documentation](#cli-documentation)
	- [Create Yggdrasil project](#create-yggdrasil-project)
	- [Typical use](#typical-use)
	- [CLI commands](#cli-commands)
		- [options](#options)
			- [Custom gitops folder](#custom-gitops-folder)
			- [Custom library path](#custom-library-path)
			- [Custom output file](#custom-output-file)
			- [Custom error file](#custom-error-file)
		- [Configuration](#configuration)
			- [Configure a scope](#configure-a-scope)
			- [Configure a platform](#configure-a-platform)
		- [Initialization](#initialization)
			- [Bootstrap a root project](#bootstrap-a-root-project)
			- [Setup root project credentials](#setup-root-project-credentials)
			- [Check SSH key pair](#check-ssh-key-pair)
			- [Collect IPs](#collect-ips)
			- [Setup Terraform scope folder](#setup-terraform-scope-folder)
			- [Register DNS](#register-dns)
		- [Terraform](#terraform)
			- [Init](#init)
			- [Apply](#apply)
			- [Plan, refresh, destroy](#plan-refresh-destroy)
			- [Import](#import)
		- [Ansible](#ansible)
		- [API services](#api-services)

## Create Yggdrasil project

If you do not have a project folder yet, you can create one with the command :

```bash
yggdrasil <PATH_TO_PROJECT_ROOT> init F
```

Once you have configured the project folder following [these instructions](project_configuration.md), you can proceed with Yggdrasil commands.

You can always display the `yggdrasil` helper even if your current working directory is not a Yggdrasil project folder.

```bash
yggdrasil # This command will dump the helper
yggdrasil --help # This command too
```

## Typical use

```bash
yggdrasil [global options] <SCOPE> <COMMAND> <SUBCOMMAND> [command options]
```

Notice : Yggdrasil commands can work either with `config/<SCOPE>` or `<SCOPE>` as their first argument. Assuming that your working directory is a well-configured Yggdrasil project, you have a `config` folder inside it, thus __autocompletion will work with `config/<SCOPE>`__

GOOD PRACTICE 2 : before answering 'yes' to ANY terraform operation, please check the 'Plan' line of the operation, to see which resources will be altered.

## CLI commands

### options

You can set the following options with Yggdrasil :

#### Custom gitops folder

By default, the `gitops` folder is the current working directory. You can set another one like this :

```bash
yggdrasil --project-root=<PATH_TO_GITOPS_FOLDER> <SCOPE> <COMMAND> <SUBCOMMAND>
```

Notice that in this case, autocompletion for SCOPE path will not work.

#### Custom library path

By default, Yggdrasil use an internal "library" to obtain Terraform modules, Ansible playbooks, Jinja configuration templates, etc. The internal library is stored in `yggdrasil/libraries` in the source code of the CLI.

You can set your own "library" path like this :

```bash
yggdrasil --libraries-path=<PATH_TO_LIBRARIES_FOLDER> <SCOPE> <COMMAND> <SUBCOMMAND>
```

#### Custom output file

By default, Yggdrasil use the standard output for all Terraform and Ansible commands.

You can set a specific file for dumping outputs like this :

```bash
yggdrasil --output-file=<PATH_TO_OUTPUT_FILE> <SCOPE> <COMMAND> <SUBCOMMAND>
```

#### Custom error file

By default, Yggdrasil use the standard error for all Terraform and Ansible commands errors.

You can set a specific file for dumping errors like this :

```bash
yggdrasil --error-file=<PATH_TO_ERROR_FILE> <SCOPE> <COMMAND> <SUBCOMMAND>
```

### Configuration

#### Configure a scope

Generate a Yggdrasil scope. This command will prompt many questions, with default answers being picked from `standard/standard.yml` file :

```bash
yggdrasil <PATH_TO_YOUR_ROOT_PROJECT> config G
```

#### Configure a platform

Generate a Yggdrasil scope for a whole "platform", i.e. a Kubernetes cluster with an optional exposition layer. This command will prompt many questions, with default answers being picked from `standard/standard.yml` file __AND__ from a `manifest` file, that can be picked by default from `manifest/default_platform_manifest.yml`, or from a folder of your choice:

```bash
yggdrasil <PATH_TO_YOUR_ROOT_PROJECT> config G --platform
```

Once the command above has finished, you will have a folder `scope/<SCOPE>` in your root Yggdrasil project, with a file `deploy.yml` inside it.

Run this command to generate a `config.yml` from the `deploy.yml`:

```bash
yggdrasil <PATH_TO_YOUR_ROOT_PROJECT>/config/<SCOPE> config D
```

Now, you have a file `config/<SCOPE>/config.yml`. You can proceed with the next steps to create the associated environment with Yggdrasil.

### Initialization

#### Bootstrap a root project

Create a bootstrap Yggdrasil root project :

```bash
yggdrasil <PATH_TO_YOUR_ROOT_PROJECT> init folder
```

#### Setup root project credentials

Setup the Yggdrasil project configuration (will have many prompts) :

```bash
yggdrasil <PATH_TO_YOUR_ROOT_PROJECT> init config
```

#### Check SSH key pair

Check if an SSH key pair is available :

```bash
yggdrasil <SCOPE> init 0
```

#### Collect IPs

Collect IPs for VMs and store them into a file `config/scopes/<SCOPE>/config_ips.yml` :

```bash
yggdrasil <SCOPE> init 1
```

You can disable SSH fingerprint checks done by Ansible by using the `-nc` (for "no check") option :

```bash
yggdrasil <SCOPE> init 1 -nc
```

It will create a `ansible.cfg` file for your scope with the extra lines:

```cfg
[defaults]
host_key_checking = False
```

By default, Yggdrasil use the username set in the root `.env` file at environment variable `CLOUDTIGER_SSH_USERNAME` to connect to your remote hosts. You can override this value and use the default SSH user associated with the OS image of every VM by using the `-d` (for "default user") option :

```bash
yggdrasil <SCOPE> init 1 -d
```

It will add a line `User <DEFAULT_OS_USER>` in the `ssh.cfg` file of your scope for every host.

#### Setup Terraform scope folder

Copy Terraform modules needed by your scope into `terraform` folder, and create a scope folder in `scopes/<SCOPE>/terraform`, based on templates in `yggdrasil/libraries/internal/terraform_providers` and .j2 files in `config/generic_terraform` :

```bash
yggdrasil <SCOPE> init 2
```

#### Register DNS

Register VM names into the DNS server defined in `standard/standard.yml`.

You must have configured these variables in the `.env` file at the root of your project folder for this command to work:

```env
export CLOUDTIGER_DNS_ADDRESS='x.x.x.x' ### address of the DNS server
export CLOUDTIGER_DNS_LOGIN='login' ### login to the DNS server
export CLOUDTIGER_DNS_PASSWORD='base64_encoded_password ### base64-encoded password for the DNS server
```

```bash
yggdrasil <SCOPE> init 5
```

### Terraform

#### Init

Run `terraform init ...` in `scopes/<SCOPE>/terraform` folder :

```bash
yggdrasil <SCOPE> tf init
```

If you get a warning message from Terraform asking you that you need to migrate the tfstate to go further, you can emulate the native `terraform init -migrate` command with the command :

```bash
yggdrasil <SCOPE> tf init --migrate
```

#### Apply

same with `terraform apply ...`, combined with `terraform output` to `scopes/<SCOPE>/inventory/terraform_output.json`:

```bash
yggdrasil <SCOPE> tf apply
```

#### Plan, refresh, destroy

You can also run `terraform plan`, `terraform refresh` and `terraform destroy` with :

```bash
yggdrasil <SCOPE> tf plan
yggdrasil <SCOPE> tf refresh
yggdrasil <SCOPE> tf destroy
```

__WARNING__ : by default, `yggdrasil <SCOPE> tf destroy` will also *delete* the `config/<SCOPE>/config_ips.yml` file

#### Import

Remove all VMs from your current tfstate, then try to import all VMs listed into the `config.yml` into the tfstate :

```bash
yggdrasil <SCOPE> tf import
```

WARNING : this command only works for Nutanix and vSphere for the moment, still experimental for AWS, Azure and GCP

### Ansible

Prepare Ansible inventory (`ssf.cfg`. `hosts.yml`) from `config.yml` and Terraform output :

```bash
yggdrasil <SCOPE> ans 1
```

Merge Ansible requirement files from `yggdrasil/libraries/ansible/requirements.yml` and `<PROJECT_ROOT>/standard/ansible_requirements.yml` into `<PROJECT_ROOT>/ansible/requirements.yml`, then run `ansible install -r ansible/requirements.yml` :

```bash
yggdrasil <SCOPE> ans D
```

Hint : Ansible by default will not try to upgrade roles already installed. You can force reinstallation (of all roles, warning !) with this option :

```bash
yggdrasil <SCOPE> ans D -F
```

Copy Ansible playbooks from `yggdrasil/libraries/ansible/playbooks` __AND__ from `<PROJECT_ROOT>/standard/playbooks` to `<PROJECT_ROOT>/ansible/playbooks`. If some playbooks have the same name, priority is for the playbooks from `<PROJECT_ROOT>/standard/playbooks`.

```bash
yggdrasil <SCOPE> ans P
```

Copy Ansible roles from `yggdrasil/libraries/ansible/roles` to `<PROJECT_ROOT>/ansible/roles`. You can now call these roles with `yggdrasil ... ans 3` command with the key `type: internal_role` in the list `ansible` in `config.yml`. See [here](./commands.md) for more details.

```bash
yggdrasil <SCOPE> ans R
```

Prepare Ansible meta-playbook `execute_ansible.yml` :

```bash
yggdrasil <SCOPE> ans 2
```

It is possible to target specific ansible section under another key than `ansible` in the `config.yml` file. If you have a key `ansible-key` defined in your `config.yml` with content using the same format as `ansible`, you can use it instead by adding the option `-a ansible-key`:

```bash
yggdrasil <SCOPE> ans 2 -a ansible-key
```

It is also possible to group multiple ansible keys using a comma-separated list of keys. In that case, the content of the ansible keys will be executed according to their order in the comma-separated list. For example, if you have a key `ansible-key-1` and a key `ansible-key-2` in your `config.yml`, you can execute the ansible tasks defined in `ansible-key-1` first, then the ones defined in `ansible-keys-2`, simply by adding the option `-a ansible-key-1,ansible-key-2`:

```bash
yggdrasil <SCOPE> ans 2 -a ansible-key-1,ansible-key-2
```

Check SSH connexion to VMs (not mandatory for executing Ansible). This command will clear all entries with hostnames and IP addresses defined in `config_ips.yml` from your SSH history, and try a first SSH connection on these addresses in order to avoid SSH warning messages of first connection attempt when you apply Ansible.

```bash
yggdrasil <SCOPE> ans H
```

If you have generated an Ansible meta-playbook `execute_ansible.yml` file, you can execute Ansible on it with :

```bash
yggdrasil <SCOPE> ans 3
```

__NOTA BENE__ : the `ans 3` command is equivalent to :
- using `scopes/<SCOPE_FOLDER>/inventory` as current working directory
- using `scopes/<SCOPE_FOLDER>/inventory/ansible.cfg` as Ansible configuration file
- using `scopes/<SCOPE_FOLDER>/inventory/ssh.cfg` as the SSH configuration file associated with Ansible
- using `scopes/<SCOPE_FOLDER>/inventory/hosts.yml` as the Ansible hosts file
- then applying `ansible-playbook` command on the `scopes/<SCOPE_FOLDER>/inventory/execute_ansible.yml` file

__WARNING__ : if you are trying to connect to newly created VMs with Ansible, you will have a warning that the fingerprint of the machine is unknown (or has changed, if you have changed the remote host), and will have a prompt to validate or reject the fingerprint.
To avoid having to validate manually many fingerprint, you can either run `yggdrasil <SCOPE> ans H` before, or add the option `--no-check/-n` :

```bash
yggdrasil <SCOPE> ans 3 -n
```

### API services

You can use Yggdrasil to configure services providing an API with a Terraform connector supported by Yggdrasil.

To this purpose, first check that you have defined the credentials for the target service in `secrets/<SERVICE_NAME>/<service_host>.env`

Currently supported services are :

- `gitlab`
- `nexus`

To create a service folder in `scopes/<SCOPE>/<SERVICE_NAME>` :

```bash
yggdrasil <SCOPE> service <SERVICE_NAME> 0
```

To run `terraform init/apply/plan/destroy` in the folder `scopes/<SCOPE>/<SERVICE_NAME>` :

```bash
yggdrasil <SCOPE> service <SERVICE_NAME> init
yggdrasil <SCOPE> service <SERVICE_NAME> plan
yggdrasil <SCOPE> service <SERVICE_NAME> apply
yggdrasil <SCOPE> service <SERVICE_NAME> destroy
```

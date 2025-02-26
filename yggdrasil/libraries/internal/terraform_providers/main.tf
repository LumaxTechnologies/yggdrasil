### reformatting of input variables
locals {

	### formatting networks
	formatted_network = { for network_key, network in var.network :
		network_key => {
			### if the network_name key is not set inside the network, we use the key defining the network itself
			### the idea is to allow a difference between the name of the network in the tfstate
			### and the name of the network in the provider
			network_name        = lookup(network, "network_name", network_key)

			### default network cidr = "0.0.0.0/24"
			network_cidr = lookup(network, "network_cidr", "0.0.0.0/24")

			### possibility to add extra labels for a given network
			module_labels     = merge(
				var.labels,
				lookup(network, "labels", {})
			)
			
			### prefix added to the name of the resource provider-side
			module_prefix       = lookup(network, "prefix", "")
			
			### here, we separate private and public (= internet-callable) subnets
			### by default subnets are private
			### we also keep only subnets that are "managed" (= whose creation is done in this scope)
			private_subnets = {
				for subnet_name, subnet in lookup(network, "subnets", {}) :
					subnet_name => subnet if (!lookup(subnet, "public", false) && !lookup(subnet, "unmanaged", false))
			}
			public_subnets = {
				for subnet_name, subnet in lookup(network, "subnets", {}) :
					subnet_name => subnet if (lookup(subnet, "public", false) && !lookup(subnet, "unmanaged", false))
			}
			
			### this variable allows to specify which public subnet will be used to reach
			### Internet for all private subnets of current network
			private_subnets_escape_public_subnet = lookup(network, "private_subnets_escape_public_subnet", "none")

			### used by public cloud providers
			location = var.region
			common_availability_zone = lookup(network, "common_availability_zone", [])
			vlan_id = lookup(network, "vlan_id", "no_relevant_vlan_id")

			### used by vsphere and nutanix
			datacenter_name = lookup(network, "datacenter", "no_datacenter_set")

			### VLAN - level firewall rules
			### injection of ingress rules
			firewall_rules_ingress = flatten([
				for subnet_name, subnet in lookup(network, "subnets", {}) : [
					for rule in lookup(subnet, "ingress_rules", {}) : {
						rule_name = format("%s_%s", rule, subnet_name)
						attached_subnet = subnet_name
						description = var.ingress_rules[rule].description
						from_port   = var.ingress_rules[rule].from_port
						to_port     = var.ingress_rules[rule].to_port
						protocol    = var.ingress_rules[rule].protocol
						access      = lookup(var.ingress_rules[rule], "access", "Allow")
						cidr        = lookup(lookup(network, "ingress_cidr", {}), rule, ["0.0.0.0/0"])
						direction   = "Inbound"
						protocol    = lookup(var.ingress_rules[rule], "protocol", "Tcp")
						source_port_range        = lookup(var.ingress_rules[rule], "source_port_range", "*")
						destination_port_range   = lookup(var.ingress_rules[rule], "destination_port_range", "*")
						priority    = var.ingress_rules[rule].priority
					}
				]
			])

			firewall_rules_egress = flatten([
				for subnet_name, subnet in lookup(network, "subnets", {}) : [
					for rule in lookup(subnet, "egress_rules", {}) : {
						rule_name = format("%s_%s", rule, subnet_name)
						attached_subnet = subnet_name
						description = var.egress_rules[rule].description
						from_port   = var.egress_rules[rule].from_port
						to_port     = var.egress_rules[rule].to_port
						protocol    = var.egress_rules[rule].protocol
						access      = lookup(var.egress_rules[rule], "access", "Allow")
						cidr        = lookup(lookup(network, "egress_cidr", {}), rule, ["0.0.0.0/0"])
						direction   = "Outbound"
						protocol    = lookup(var.egress_rules[rule], "protocol", "Tcp")
						source_port_range        = lookup(var.egress_rules[rule], "source_port_range", "*")
						destination_port_range   = lookup(var.egress_rules[rule], "destination_port_range", "*")
						priority    = var.ingress_rules[rule].priority
					}
				]
			])
		}
	}

	### formatting SSH keys
	formatted_ssh_keys = (var.ssh_public_key != "no_default_public_key") ? { basename(var.ssh_public_key) : {"key_name" : basename(var.ssh_public_key), "public_key" : file(var.ssh_public_key)}} : {}

	### formatting virtual machines, including preparing default values
	formatted_vm_list = flatten([
		for network_name, network_vms in var.vm : [
			for subnet_name, subnet_vms in network_vms : [
				for vm_name, vm in subnet_vms : {
					### the vm_full_name include the prefix, where the vm_name does not - the vm_full_name is used in the Terraform output
					### for the mapping VMs/IPs
					vm_full_name = format("%s%s_vm", lookup(vm, "prefix", ""), vm_name)

					vm_tf_name = vm_name
					vm_name = lookup(vm, "vm_name", vm_name)
					
					### network/subnetwork information
					network_name = network_name
					subnet_name = subnet_name
					
					### labels + prefix
					module_labels     = merge(
						var.labels,
						lookup(vm, "labels", {})
					)
					module_prefix       = lookup(vm, "prefix", "")
					common_prefix       = var.prefix
					group = lookup(vm, "group", lookup(vm, "type", "custom"))

					### OS system image
					system_image = lookup(
						var.system_images[var.cloud_provider],
						lookup(vm, "system_image", "ubuntu_server_2204")
					)["name"]

					### default OS user
					### order of checking :
					### vm.user
					### system_images[provider][username]
					### default_os_user[provider]
					user = lookup(vm, "os_user",
						lookup(
							var.system_images[var.cloud_provider][lookup(vm, "system_image", "ubuntu_server_2204")],
							"username",
							lookup(var.default_os_user, var.cloud_provider, var.default_os_user["default"])
						)
					)

					### instance technical specs
					### order of checking :
					### vm[size]
					### vm_types[provider][vm[type][vm[caliber]]
					### (if no vm type provided, "custom" type by default)
					### (if no caliber provided, "nonprod" type by default)
					instance_type = lookup(
						vm,
						"size",
						lookup(
							lookup(
								lookup(
									var.vm_types, 
									var.cloud_provider, 
									var.vm_types["default"]
								),
								lookup(vm, "type", "custom"),
								{}
							),
							lookup(vm, "caliber", "nonprod"),
							{}
						)
					)

					### instance profile
					instance_profile_name = lookup(vm, "instance_profile", "default")

					### used by public cloud providers
					location = var.region
					### used by public cloud providers
					availability_zone = lookup(vm, "availability_zone", "no_availability_zone")
					
					### is the VM's subnet private or public ? by default private
					subnet_type = lookup(vm, "subnet_type", "private")
					
					### if no private IP set, it will be learned at creation
					private_ip = lookup(vm, "private_ip", "not_learned_yet")

					### vm type (useful for default technical specs)
					type = lookup(vm, "type", "custom")

					### setting the volumes
					root_volume = lookup(
						lookup(vm, "volumes", {}), 
						"root", 
						{"type": lookup(lookup(var.generic_volume_parameters, var.cloud_provider, var.generic_volume_parameters["default"]), lookup(vm, "root_volume_type", "custom"), {"type":"no_type_set"})["type"]
						"size": lookup(lookup(var.generic_volume_parameters, var.cloud_provider, var.generic_volume_parameters["default"]), lookup(vm, "root_volume_type", "custom"), {"size":16})["size"]
						}
					)
					root_volume_size = lookup(vm, "root_volume_size", 16) # * 1024
					default_root_volume_size = 16

					data_volumes = {
						for volume_name, volume in lookup(
							vm, 
							"volumes", 
							{"data": {"type": lookup(lookup(var.generic_volume_parameters, var.cloud_provider, var.generic_volume_parameters["default"]), lookup(vm, "data_volume_type", "none"), {"type":"no_type_set"})["type"], "index": "1"}}
							) :
						volume_name => volume if volume_name != "root"
					}

					default_data_volume_size = lookup(
						vm,
						"data_volume_size",
						lookup(
							lookup(
								lookup(
									lookup(
										var.vm_types, 
										var.cloud_provider, 
										var.vm_types["default"]
									),
									lookup(vm, "type", "custom")
								),
								lookup(vm, "caliber", "nonprod")
							),
							"data_volume_size"
						)
					)

					### generic_volume_parameters is a map providing default sizes in Go for template values for disk sizes
					generic_volume_parameters = lookup(var.generic_volume_parameters, var.cloud_provider, var.generic_volume_parameters["default"])

					### by default, VMs on public cloud providers need the name of a public SSH key on the account
					ssh_public_key = lookup(vm, "ssh_key", basename(var.ssh_public_key))
					ssh_public_key_path = var.ssh_public_key

					### injection of ingress rules data
					ingress_rules = { for rule in lookup(vm, "ingress_rules", {}) :
						rule => {
							description = var.ingress_rules[rule].description
							from_port   = var.ingress_rules[rule].from_port
							to_port     = var.ingress_rules[rule].to_port
							protocol    = var.ingress_rules[rule].protocol
							cidr        = lookup(lookup(vm, "ingress_cidr", {}), rule, var.ingress_rules[rule].cidr)
							priority    = lookup(lookup(vm, "priorities", {}), rule, var.ingress_rules[rule].priority)
						}
					}
					### injection of egress rules data
					egress_rules = { for rule in lookup(vm, "egress_rules", {}) :
						rule => {
							description = var.egress_rules[rule].description
							from_port   = var.egress_rules[rule].from_port
							to_port     = var.egress_rules[rule].to_port
							protocol    = var.egress_rules[rule].protocol
							cidr        = lookup(lookup(vm, "egress_cidr", {}), rule, var.egress_rules[rule].cidr)
							priority    = lookup(lookup(vm, "priorities", {}), rule, var.egress_rules[rule].priority)
						}
					}

					# ### will the VM be publicly available on Internet ? default false
					# exposed_vm_required = lookup(vm, "exposed_vm_required", "false")

					### do we use cloudinit to set some files on the VM at creation ? default false
					cloudinit = lookup(vm, "cloudinit", false)

					### specify datacenter (if needed)
					datacenter = lookup(vm, "datacenter", "non_relevant")

					### some very custom parameters (provider-dependant typically)
					extra_parameters = lookup(vm, "extra_parameters", {})

					### check if the machine is already existing,
					### for example to avoid destroying considering immutable parameters)
					machine_does_exist = lookup(vm, "machine_does_exist", false)

					### parameter that allows to know if the VM has already been created
					### outside of Yggdrasil and is simply imported
					imported = lookup(vm, "imported", "false")

					### used by vsphere
					folder = lookup(vm, "folder", var.scope_folder)

					### used by vsphere for identifying templates
					is_template = lookup(vm, "is_template", false)

					### used by non-cloud providers
					default_password = var.default_password
					users_list = var.users_list
					domain_ldap = var.domain_ldap
					ou_ldap = var.ou_ldap
					user_ldap_join = var.user_ldap_join
					password_user_ldap_join = var.password_user_ldap_join
					ldap_user_search_base = var.ldap_user_search_base
					ldap_sudo_search_base = var.ldap_sudo_search_base
					ad_groups = lookup(vm, "ad_groups", [])
				}
			]
		]
	])

	### flattening the formatted_vm_list
	formatted_vm = { for vm in local.formatted_vm_list :
		vm.vm_tf_name => vm if (!lookup(vm, "is_template", false))
	}

	formatted_vm_templates = { for vm in local.formatted_vm_list :
		vm.vm_tf_name => vm if lookup(vm, "is_template", false)
	}

	### formatting kubernetes clusters
	formatted_k8s = { for k8s_key, k8s_cluster in var.kubernetes :
		k8s_key => {
			cluster_name  = lookup(k8s_cluster, "cluster_name", k8s_key)

			network = k8s_cluster.network
			subnetworks = k8s_cluster.subnetworks

			### labels + prefix
			module_labels     = merge(
				var.labels,
				lookup(k8s_cluster, "labels", {})
			)
			module_prefix       = lookup(k8s_cluster, "prefix", "")

			### useful for public cloud providers
			zones = lookup(k8s_cluster, "zones", var.region)
			location = var.region

			### useful for SOME public cloud providers
			username = lookup(k8s_cluster, "username", "none")
			password = lookup(k8s_cluster, "password", "none")

			### OS system image for the nodes
			system_image = lookup(var.system_images[var.cloud_provider], k8s_cluster.system_image)

			### technical specifications of nodes
			instance_type = lookup(
						lookup(
							lookup(
								var.vm_types, 
								var.cloud_provider, 
								var.vm_types["default"]
							),
							lookup(k8s_cluster, "instance_type", "custom"),
							{}
						),
						lookup(k8s_cluster, "caliber", "nonprod"),
						"k8s_instance_type_unset"
					)
			
			
			# lookup(lookup(lookup(var.vm_types, var.cloud_provider, var.vm_types["default"]), k8s_cluster.instance_type, {}), lookup(k8s_cluster, "caliber", "nonprod"), "k8s_instance_type_unset")

			### definition node groups
			k8s_node_groups = k8s_cluster.k8s_node_groups
			# k8s_instance_types = { for node_group_name, node_group in k8s_cluster.k8s_node_groups :
			# 	node_group_name => lookup(lookup(var.vm_types, var.cloud_provider, var.vm_types["default"]), lookup(node_group, "instance_type", k8s_cluster.instance_type), k8s_cluster.instance_type)
			# }

			### cluster volumes
			dedicated_volumes = k8s_cluster.cluster_volumes

			### injection of ingress rules data
			ingress_rules = { for rule in k8s_cluster.ingress_rules :
				rule => {
					description = var.ingress_rules[rule].description
					from_port   = var.ingress_rules[rule].from_port
					to_port     = var.ingress_rules[rule].to_port
					protocol    = var.ingress_rules[rule].protocol
					cidr        = lookup(lookup(k8s_cluster, "ingress_cidr", {}), rule, ["0.0.0.0/0"])
				}
			}
			### injection of egress rules data
			egress_rules = { for rule in k8s_cluster.egress_rules :
				rule => {
					description = var.egress_rules[rule].description
					from_port   = var.egress_rules[rule].from_port
					to_port     = var.egress_rules[rule].to_port
					protocol    = var.egress_rules[rule].protocol
					cidr        = lookup(lookup(k8s_cluster, "egress_cidr", {}), rule, ["0.0.0.0/0"])
				}
			}

			### by default, managed K8s clusters on public cloud providers need the name of a public SSH key on the account
			ssh_public_key = lookup(k8s_cluster, "ssh_key", basename(var.ssh_public_key))
			ssh_public_key_path = var.ssh_public_key

			### custom parameters
			az_custom_parameters = lookup(k8s_cluster, "az_custom_parameters", {})
			nutanix_custom_parameters = lookup(k8s_cluster, "nutanix_custom_parameters", {})
		}
	}

	### formatting independent volumes (= non binded to specific VMs)
	formatted_independent_volumes = { for volume_name, volume in var.independent_volumes :
		volume_name => {
			zone = var.region
			size = volume.size
			module_labels     = merge(
				var.labels,
				lookup(volume, "labels", {})
			)
			module_prefix = lookup(volume, "prefix", "")
			name = lookup(volume, "name", volume_name)
		}
	}

}
terraform {
  required_providers {
    fortios = {
      source = "fortinetdev/fortios"
      version = "1.15.0"
    }
  }
}

resource "fortios_vpnipsec_phase1interface" "trnamex1" {
  name  = lookup(var.vpnipsec_phase1interface, "name ", null )
  type  = lookup(var.vpnipsec_phase1interface, "type ", null ) # Valid values: static, dynamic, ddns
  interface  = lookup(var.vpnipsec_phase1interface, "interface ", null )
  ip_version  = lookup(var.vpnipsec_phase1interface, "ip_version ", null ) # Valid values: 4, 6
  ike_version  = lookup(var.vpnipsec_phase1interface, "ike_version ", null ) # Valid values: 1, 2
  local_gw  = lookup(var.vpnipsec_phase1interface, "local_gw ", null )
  local_gw6  = lookup(var.vpnipsec_phase1interface, "local_gw6 ", null )
  remote_gw  = lookup(var.vpnipsec_phase1interface, "remote_gw ", null )
  remote_gw6  = lookup(var.vpnipsec_phase1interface, "remote_gw6 ", null )
  remotegw_ddns  = lookup(var.vpnipsec_phase1interface, "remotegw_ddns ", null )
  keylife  = lookup(var.vpnipsec_phase1interface, "keylife ", null )
  # certificate  = lookup(var.vpnipsec_phase1interface, "certificate ", null )
  authmethod  = lookup(var.vpnipsec_phase1interface, "authmethod ", null ) # Valid values: psk, signature
  authmethod_remote  = lookup(var.vpnipsec_phase1interface, "authmethod_remote ", null ) # Valid values: psk, signature
  mode  = lookup(var.vpnipsec_phase1interface, "mode ", null ) # Valid values: aggressive, main
  peertype  = lookup(var.vpnipsec_phase1interface, "peertype ", null ) # Valid values: any, one, dialup, peer, peergrp
  peerid  = lookup(var.vpnipsec_phase1interface, "peerid ", null )
  default_gw  = lookup(var.vpnipsec_phase1interface, "default_gw ", null )
  default_gw_priority  = lookup(var.vpnipsec_phase1interface, "default_gw_priority ", null )
  usrgrp  = lookup(var.vpnipsec_phase1interface, "usrgrp ", null )
  peer  = lookup(var.vpnipsec_phase1interface, "peer ", null )
  peergrp  = lookup(var.vpnipsec_phase1interface, "peergrp ", null )
  monitor  = lookup(var.vpnipsec_phase1interface, "monitor ", null )
  monitor_hold_down_type  = lookup(var.vpnipsec_phase1interface, "monitor_hold_down_type ", null ) # Valid values: immediate, delay, time
  monitor_hold_down_delay  = lookup(var.vpnipsec_phase1interface, "monitor_hold_down_delay ", null )
  monitor_hold_down_weekday  = lookup(var.vpnipsec_phase1interface, "monitor_hold_down_weekday ", null ) # Valid values: everyday, sunday, monday, tuesday, wednesday, thursday, friday, saturday
  monitor_hold_down_time  = lookup(var.vpnipsec_phase1interface, "monitor_hold_down_time ", null )
  net_device  = lookup(var.vpnipsec_phase1interface, "net_device ", null ) # Valid values: enable, disable
  tunnel_search  = lookup(var.vpnipsec_phase1interface, "tunnel_search ", null ) # Valid values: selectors, nexthop
  passive_mode  = lookup(var.vpnipsec_phase1interface, "passive_mode ", null ) # Valid values: enable, disable
  exchange_interface_ip  = lookup(var.vpnipsec_phase1interface, "exchange_interface_ip ", null ) # Valid values: enable, disable
  exchange_ip_addr4  = lookup(var.vpnipsec_phase1interface, "exchange_ip_addr4 ", null )
  exchange_ip_addr6  = lookup(var.vpnipsec_phase1interface, "exchange_ip_addr6 ", null )
  aggregate_member  = lookup(var.vpnipsec_phase1interface, "aggregate_member ", null ) # Valid values: enable, disable
  aggregate_weight  = lookup(var.vpnipsec_phase1interface, "aggregate_weight ", null )
  mode_cfg  = lookup(var.vpnipsec_phase1interface, "mode_cfg ", null ) # Valid values: disable, enable
  mode_cfg_allow_client_selector  = lookup(var.vpnipsec_phase1interface, "mode_cfg_allow_client_selector ", null ) # Valid values: disable, enable
  assign_ip  = lookup(var.vpnipsec_phase1interface, "assign_ip ", null ) # Valid values: disable, enable
  assign_ip_from  = lookup(var.vpnipsec_phase1interface, "assign_ip_from ", null ) # Valid values: range, usrgrp, dhcp, name
  ipv4_start_ip  = lookup(var.vpnipsec_phase1interface, "ipv4_start_ip ", null )
  ipv4_end_ip  = lookup(var.vpnipsec_phase1interface, "ipv4_end_ip ", null )
  ipv4_netmask  = lookup(var.vpnipsec_phase1interface, "ipv4_netmask ", null )
  dhcp_ra_giaddr  = lookup(var.vpnipsec_phase1interface, "dhcp_ra_giaddr ", null )
  dhcp6_ra_linkaddr  = lookup(var.vpnipsec_phase1interface, "dhcp6_ra_linkaddr ", null )
  dns_mode  = lookup(var.vpnipsec_phase1interface, "dns_mode ", null ) # Valid values: manual, auto
  ipv4_dns_server1  = lookup(var.vpnipsec_phase1interface, "ipv4_dns_server1 ", null )
  ipv4_dns_server2  = lookup(var.vpnipsec_phase1interface, "ipv4_dns_server2 ", null )
  ipv4_dns_server3  = lookup(var.vpnipsec_phase1interface, "ipv4_dns_server3 ", null )
  ipv4_wins_server1  = lookup(var.vpnipsec_phase1interface, "ipv4_wins_server1 ", null )
  ipv4_wins_server2  = lookup(var.vpnipsec_phase1interface, "ipv4_wins_server2 ", null )
  # ipv4_exclude_range  = lookup(var.vpnipsec_phase1interface, "ipv4_exclude_range ", null )
  ipv4_split_include  = lookup(var.vpnipsec_phase1interface, "ipv4_split_include ", null )
  split_include_service  = lookup(var.vpnipsec_phase1interface, "split_include_service ", null )
  ipv4_name  = lookup(var.vpnipsec_phase1interface, "ipv4_name ", null )
  ipv6_start_ip  = lookup(var.vpnipsec_phase1interface, "ipv6_start_ip ", null )
  ipv6_end_ip  = lookup(var.vpnipsec_phase1interface, "ipv6_end_ip ", null )
  ipv6_prefix  = lookup(var.vpnipsec_phase1interface, "ipv6_prefix ", null )
  ipv6_dns_server1  = lookup(var.vpnipsec_phase1interface, "ipv6_dns_server1 ", null )
  ipv6_dns_server2  = lookup(var.vpnipsec_phase1interface, "ipv6_dns_server2 ", null )
  ipv6_dns_server3  = lookup(var.vpnipsec_phase1interface, "ipv6_dns_server3 ", null )
  # ipv6_exclude_range  = lookup(var.vpnipsec_phase1interface, "ipv6_exclude_range ", null )
  ipv6_split_include  = lookup(var.vpnipsec_phase1interface, "ipv6_split_include ", null )
  ipv6_name  = lookup(var.vpnipsec_phase1interface, "ipv6_name ", null )
  ip_delay_interval  = lookup(var.vpnipsec_phase1interface, "ip_delay_interval ", null )
  unity_support  = lookup(var.vpnipsec_phase1interface, "unity_support ", null ) # Valid values: disable, enable
  domain  = lookup(var.vpnipsec_phase1interface, "domain ", null )
  banner  = lookup(var.vpnipsec_phase1interface, "banner ", null )
  include_local_lan  = lookup(var.vpnipsec_phase1interface, "include_local_lan ", null ) # Valid values: disable, enable
  ipv4_split_exclude  = lookup(var.vpnipsec_phase1interface, "ipv4_split_exclude ", null )
  ipv6_split_exclude  = lookup(var.vpnipsec_phase1interface, "ipv6_split_exclude ", null )
  save_password  = lookup(var.vpnipsec_phase1interface, "save_password ", null ) # Valid values: disable, enable
  client_auto_negotiate  = lookup(var.vpnipsec_phase1interface, "client_auto_negotiate ", null ) # Valid values: disable, enable
  client_keep_alive  = lookup(var.vpnipsec_phase1interface, "client_keep_alive ", null ) # Valid values: disable, enable
  # backup_gateway  = lookup(var.vpnipsec_phase1interface, "backup_gateway ", null )
  proposal  = lookup(var.vpnipsec_phase1interface, "proposal ", null ) # Valid values: des-md5, des-sha1, des-sha256, des-sha384, des-sha512, 3des-md5, 3des-sha1, 3des-sha256, 3des-sha384, 3des-sha512, aes128-md5, aes128-sha1, aes128-sha256, aes128-sha384, aes128-sha512, aes128gcm-prfsha1, aes128gcm-prfsha256, aes128gcm-prfsha384, aes128gcm-prfsha512, aes192-md5, aes192-sha1, aes192-sha256, aes192-sha384, aes192-sha512, aes256-md5, aes256-sha1, aes256-sha256, aes256-sha384, aes256-sha512, aes256gcm-prfsha1, aes256gcm-prfsha256, aes256gcm-prfsha384, aes256gcm-prfsha512, chacha20poly1305-prfsha1, chacha20poly1305-prfsha256, chacha20poly1305-prfsha384, chacha20poly1305-prfsha512, aria128-md5, aria128-sha1, aria128-sha256, aria128-sha384, aria128-sha512, aria192-md5, aria192-sha1, aria192-sha256, aria192-sha384, aria192-sha512, aria256-md5, aria256-sha1, aria256-sha256, aria256-sha384, aria256-sha512, seed-md5, seed-sha1, seed-sha256, seed-sha384, seed-sha512
  add_route  = lookup(var.vpnipsec_phase1interface, "add_route ", null ) # Valid values: disable, enable
  add_gw_route  = lookup(var.vpnipsec_phase1interface, "add_gw_route ", null ) # Valid values: enable, disable
  psksecret  = lookup(var.vpnipsec_phase1interface, "psksecret ", null )
  psksecret_remote  = lookup(var.vpnipsec_phase1interface, "psksecret_remote ", null )
  keepalive  = lookup(var.vpnipsec_phase1interface, "keepalive ", null )
  distance  = lookup(var.vpnipsec_phase1interface, "distance ", null )
  priority  = lookup(var.vpnipsec_phase1interface, "priority ", null )
  localid  = lookup(var.vpnipsec_phase1interface, "localid ", null )
  localid_type  = lookup(var.vpnipsec_phase1interface, "localid_type ", null ) # Valid values: auto, fqdn, user-fqdn, keyid, address, asn1dn
  auto_negotiate  = lookup(var.vpnipsec_phase1interface, "auto_negotiate ", null ) # Valid values: enable, disable
  negotiate_timeout  = lookup(var.vpnipsec_phase1interface, "negotiate_timeout ", null )
  fragmentation  = lookup(var.vpnipsec_phase1interface, "fragmentation ", null ) # Valid values: enable, disable
  ip_fragmentation  = lookup(var.vpnipsec_phase1interface, "ip_fragmentation ", null ) # Valid values: pre-encapsulation, post-encapsulation
  dpd  = lookup(var.vpnipsec_phase1interface, "dpd ", null ) # Valid values: disable, on-idle, on-demand
  dpd_retrycount  = lookup(var.vpnipsec_phase1interface, "dpd_retrycount ", null )
  dpd_retryinterval  = lookup(var.vpnipsec_phase1interface, "dpd_retryinterval ", null )
  forticlient_enforcement  = lookup(var.vpnipsec_phase1interface, "forticlient_enforcement ", null ) # Valid values: enable, disable
  comments  = lookup(var.vpnipsec_phase1interface, "comments ", null )
  npu_offload  = lookup(var.vpnipsec_phase1interface, "npu_offload ", null ) # Valid values: enable, disable
  send_cert_chain  = lookup(var.vpnipsec_phase1interface, "send_cert_chain ", null ) # Valid values: enable, disable
  dhgrp  = lookup(var.vpnipsec_phase1interface, "dhgrp ", null ) # Valid values: 1, 2, 5, 14, 15, 16, 17, 18, 19, 20, 21, 27, 28, 29, 30, 31, 32
  suite_b  = lookup(var.vpnipsec_phase1interface, "suite_b ", null ) # Valid values: disable, suite-b-gcm-128, suite-b-gcm-256
  eap  = lookup(var.vpnipsec_phase1interface, "eap ", null ) # Valid values: enable, disable
  eap_identity  = lookup(var.vpnipsec_phase1interface, "eap_identity ", null ) # Valid values: use-id-payload, send-request
  eap_exclude_peergrp  = lookup(var.vpnipsec_phase1interface, "eap_exclude_peergrp ", null )
  acct_verify  = lookup(var.vpnipsec_phase1interface, "acct_verify ", null ) # Valid values: enable, disable
  ppk  = lookup(var.vpnipsec_phase1interface, "ppk ", null ) # Valid values: disable, allow, require
  ppk_secret  = lookup(var.vpnipsec_phase1interface, "ppk_secret ", null )
  ppk_identity  = lookup(var.vpnipsec_phase1interface, "ppk_identity ", null )
  wizard_type  = lookup(var.vpnipsec_phase1interface, "wizard_type ", null )
  xauthtype  = lookup(var.vpnipsec_phase1interface, "xauthtype ", null ) # Valid values: disable, client, pap, chap, auto
  reauth  = lookup(var.vpnipsec_phase1interface, "reauth ", null ) # Valid values: disable, enable
  authusr  = lookup(var.vpnipsec_phase1interface, "authusr ", null )
  authpasswd  = lookup(var.vpnipsec_phase1interface, "authpasswd ", null )
  group_authentication  = lookup(var.vpnipsec_phase1interface, "group_authentication ", null ) # Valid values: enable, disable
  group_authentication_secret  = lookup(var.vpnipsec_phase1interface, "group_authentication_secret ", null )
  authusrgrp  = lookup(var.vpnipsec_phase1interface, "authusrgrp ", null )
  mesh_selector_type  = lookup(var.vpnipsec_phase1interface, "mesh_selector_type ", null ) # Valid values: disable, subnet, host
  idle_timeout  = lookup(var.vpnipsec_phase1interface, "idle_timeout ", null ) # Valid values: enable, disable
  idle_timeoutinterval  = lookup(var.vpnipsec_phase1interface, "idle_timeoutinterval ", null )
  ha_sync_esp_seqno  = lookup(var.vpnipsec_phase1interface, "ha_sync_esp_seqno ", null ) # Valid values: enable, disable
  inbound_dscp_copy  = lookup(var.vpnipsec_phase1interface, "inbound_dscp_copy ", null ) # Valid values: enable, disable
  auto_discovery_sender  = lookup(var.vpnipsec_phase1interface, "auto_discovery_sender ", null ) # Valid values: enable, disable
  auto_discovery_receiver  = lookup(var.vpnipsec_phase1interface, "auto_discovery_receiver ", null ) # Valid values: enable, disable
  auto_discovery_forwarder  = lookup(var.vpnipsec_phase1interface, "auto_discovery_forwarder ", null ) # Valid values: enable, disable
  auto_discovery_psk  = lookup(var.vpnipsec_phase1interface, "auto_discovery_psk ", null ) # Valid values: enable, disable
  auto_discovery_shortcuts  = lookup(var.vpnipsec_phase1interface, "auto_discovery_shortcuts ", null ) # Valid values: independent, dependent
  auto_discovery_offer_interval  = lookup(var.vpnipsec_phase1interface, "auto_discovery_offer_interval ", null )
  encapsulation  = lookup(var.vpnipsec_phase1interface, "encapsulation ", null )
  encapsulation_address  = lookup(var.vpnipsec_phase1interface, "encapsulation_address ", null ) # Valid values: ike, ipv4, ipv6
  encap_local_gw4  = lookup(var.vpnipsec_phase1interface, "encap_local_gw4 ", null )
  encap_local_gw6  = lookup(var.vpnipsec_phase1interface, "encap_local_gw6 ", null )
  encap_remote_gw4  = lookup(var.vpnipsec_phase1interface, "encap_remote_gw4 ", null )
  encap_remote_gw6  = lookup(var.vpnipsec_phase1interface, "encap_remote_gw6 ", null )
  vni  = lookup(var.vpnipsec_phase1interface, "vni ", null )
  nattraversal  = lookup(var.vpnipsec_phase1interface, "nattraversal ", null ) # Valid values: enable, disable, forced
  esn  = lookup(var.vpnipsec_phase1interface, "esn ", null ) # Valid values: require, allow, disable
  fragmentation_mtu  = lookup(var.vpnipsec_phase1interface, "fragmentation_mtu ", null )
  childless_ike  = lookup(var.vpnipsec_phase1interface, "childless_ike ", null ) # Valid values: enable, disable
  rekey  = lookup(var.vpnipsec_phase1interface, "rekey ", null ) # Valid values: enable, disable
  digital_signature_auth  = lookup(var.vpnipsec_phase1interface, "digital_signature_auth ", null ) # Valid values: enable, disable
  signature_hash_alg  = lookup(var.vpnipsec_phase1interface, "signature_hash_alg ", null ) # Valid values: sha1, sha2-256, sha2-384, sha2-512
  rsa_signature_format  = lookup(var.vpnipsec_phase1interface, "rsa_signature_format ", null ) # Valid values: pkcs1, pss
  enforce_unique_id  = lookup(var.vpnipsec_phase1interface, "enforce_unique_id ", null ) # Valid values: disable, keep-new, keep-old
  cert_id_validation  = lookup(var.vpnipsec_phase1interface, "cert_id_validation ", null ) # Valid values: enable, disable
  fec_egress  = lookup(var.vpnipsec_phase1interface, "fec_egress ", null ) # Valid values: enable, disable
  fec_send_timeout  = lookup(var.vpnipsec_phase1interface, "fec_send_timeout ", null )
  fec_base  = lookup(var.vpnipsec_phase1interface, "fec_base ", null )
  fec_codec  = lookup(var.vpnipsec_phase1interface, "fec_codec ", null )
  fec_redundant  = lookup(var.vpnipsec_phase1interface, "fec_redundant ", null )
  fec_ingress  = lookup(var.vpnipsec_phase1interface, "fec_ingress ", null ) # Valid values: enable, disable
  fec_receive_timeout  = lookup(var.vpnipsec_phase1interface, "fec_receive_timeout ", null )
  fec_health_check  = lookup(var.vpnipsec_phase1interface, "fec_health_check ", null )
  fec_mapping_profile  = lookup(var.vpnipsec_phase1interface, "fec_mapping_profile ", null )
  network_overlay  = lookup(var.vpnipsec_phase1interface, "network_overlay ", null ) # Valid values: disable, enable
  network_id  = lookup(var.vpnipsec_phase1interface, "network_id ", null )
  loopback_asymroute  = lookup(var.vpnipsec_phase1interface, "loopback_asymroute ", null ) # Valid values: enable, disable
  dynamic_sort_subtable  = lookup(var.vpnipsec_phase1interface, "dynamic_sort_subtable ", null )
  vdomparam  = lookup(var.vpnipsec_phase1interface, "vdomparam ", null )

}
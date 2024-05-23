terraform {
  required_providers {
    fortios = {
      source = "fortinetdev/fortios"
      version = "1.15.0"
    }
  }
}

resource "fortios_vpnipsec_phase1" "trnamex1" {
  name  = lookup(var.vpnipsec_phase1, "name ", null )
  type  = lookup(var.vpnipsec_phase1, "type ", null ) # Valid values: static, dynamic, ddns
  interface  = lookup(var.vpnipsec_phase1, "interface ", null )
  ike_version  = lookup(var.vpnipsec_phase1, "ike_version ", null ) # Valid values: 1, 2
  remote_gw  = lookup(var.vpnipsec_phase1, "remote_gw ", null )
  local_gw  = lookup(var.vpnipsec_phase1, "local_gw ", null )
  remotegw_ddns  = lookup(var.vpnipsec_phase1, "remotegw_ddns ", null )
  keylife  = lookup(var.vpnipsec_phase1, "keylife ", null )
  # certificate  = lookup(var.vpnipsec_phase1, "certificate ", null )
  authmethod  = lookup(var.vpnipsec_phase1, "authmethod ", null ) # Valid values: psk, signature
  authmethod_remote  = lookup(var.vpnipsec_phase1, "authmethod_remote ", null ) # Valid values: psk, signature
  mode  = lookup(var.vpnipsec_phase1, "mode ", null ) # Valid values: aggressive, main
  peertype  = lookup(var.vpnipsec_phase1, "peertype ", null ) # Valid values: any, one, dialup, peer, peergrp
  peerid  = lookup(var.vpnipsec_phase1, "peerid ", null )
  usrgrp  = lookup(var.vpnipsec_phase1, "usrgrp ", null )
  peer  = lookup(var.vpnipsec_phase1, "peer ", null )
  peergrp  = lookup(var.vpnipsec_phase1, "peergrp ", null )
  mode_cfg  = lookup(var.vpnipsec_phase1, "mode_cfg ", null ) # Valid values: disable, enable
  mode_cfg_allow_client_selector  = lookup(var.vpnipsec_phase1, "mode_cfg_allow_client_selector ", null ) # Valid values: disable, enable
  assign_ip  = lookup(var.vpnipsec_phase1, "assign_ip ", null ) # Valid values: disable, enable
  assign_ip_from  = lookup(var.vpnipsec_phase1, "assign_ip_from ", null ) # Valid values: range, usrgrp, dhcp, name
  ipv4_start_ip  = lookup(var.vpnipsec_phase1, "ipv4_start_ip ", null )
  ipv4_end_ip  = lookup(var.vpnipsec_phase1, "ipv4_end_ip ", null )
  ipv4_netmask  = lookup(var.vpnipsec_phase1, "ipv4_netmask ", null )
  dhcp_ra_giaddr  = lookup(var.vpnipsec_phase1, "dhcp_ra_giaddr ", null )
  dhcp6_ra_linkaddr  = lookup(var.vpnipsec_phase1, "dhcp6_ra_linkaddr ", null )
  dns_mode  = lookup(var.vpnipsec_phase1, "dns_mode ", null ) # Valid values: manual, auto
  ipv4_dns_server1  = lookup(var.vpnipsec_phase1, "ipv4_dns_server1 ", null )
  ipv4_dns_server2  = lookup(var.vpnipsec_phase1, "ipv4_dns_server2 ", null )
  ipv4_dns_server3  = lookup(var.vpnipsec_phase1, "ipv4_dns_server3 ", null )
  ipv4_wins_server1  = lookup(var.vpnipsec_phase1, "ipv4_wins_server1 ", null )
  ipv4_wins_server2  = lookup(var.vpnipsec_phase1, "ipv4_wins_server2 ", null )
  # ipv4_exclude_range  = lookup(var.vpnipsec_phase1, "ipv4_exclude_range ", null )
  ipv4_split_include  = lookup(var.vpnipsec_phase1, "ipv4_split_include ", null )
  split_include_service  = lookup(var.vpnipsec_phase1, "split_include_service ", null )
  ipv4_name  = lookup(var.vpnipsec_phase1, "ipv4_name ", null )
  ipv6_start_ip  = lookup(var.vpnipsec_phase1, "ipv6_start_ip ", null )
  ipv6_end_ip  = lookup(var.vpnipsec_phase1, "ipv6_end_ip ", null )
  ipv6_prefix  = lookup(var.vpnipsec_phase1, "ipv6_prefix ", null )
  ipv6_dns_server1  = lookup(var.vpnipsec_phase1, "ipv6_dns_server1 ", null )
  ipv6_dns_server2  = lookup(var.vpnipsec_phase1, "ipv6_dns_server2 ", null )
  ipv6_dns_server3  = lookup(var.vpnipsec_phase1, "ipv6_dns_server3 ", null )
  # ipv6_exclude_range  = lookup(var.vpnipsec_phase1, "ipv6_exclude_range ", null )
  ipv6_split_include  = lookup(var.vpnipsec_phase1, "ipv6_split_include ", null )
  ipv6_name  = lookup(var.vpnipsec_phase1, "ipv6_name ", null )
  ip_delay_interval  = lookup(var.vpnipsec_phase1, "ip_delay_interval ", null )
  unity_support  = lookup(var.vpnipsec_phase1, "unity_support ", null ) # Valid values: disable, enable
  domain  = lookup(var.vpnipsec_phase1, "domain ", null )
  banner  = lookup(var.vpnipsec_phase1, "banner ", null )
  include_local_lan  = lookup(var.vpnipsec_phase1, "include_local_lan ", null ) # Valid values: disable, enable
  ipv4_split_exclude  = lookup(var.vpnipsec_phase1, "ipv4_split_exclude ", null )
  ipv6_split_exclude  = lookup(var.vpnipsec_phase1, "ipv6_split_exclude ", null )
  save_password  = lookup(var.vpnipsec_phase1, "save_password ", null ) # Valid values: disable, enable
  client_auto_negotiate  = lookup(var.vpnipsec_phase1, "client_auto_negotiate ", null ) # Valid values: disable, enable
  client_keep_alive  = lookup(var.vpnipsec_phase1, "client_keep_alive ", null ) # Valid values: disable, enable
  # backup_gateway  = lookup(var.vpnipsec_phase1, "backup_gateway ", null )
  proposal  = lookup(var.vpnipsec_phase1, "proposal ", null ) # Valid values: des-md5, des-sha1, des-sha256, des-sha384, des-sha512, 3des-md5, 3des-sha1, 3des-sha256, 3des-sha384, 3des-sha512, aes128-md5, aes128-sha1, aes128-sha256, aes128-sha384, aes128-sha512, aes128gcm-prfsha1, aes128gcm-prfsha256, aes128gcm-prfsha384, aes128gcm-prfsha512, aes192-md5, aes192-sha1, aes192-sha256, aes192-sha384, aes192-sha512, aes256-md5, aes256-sha1, aes256-sha256, aes256-sha384, aes256-sha512, aes256gcm-prfsha1, aes256gcm-prfsha256, aes256gcm-prfsha384, aes256gcm-prfsha512, chacha20poly1305-prfsha1, chacha20poly1305-prfsha256, chacha20poly1305-prfsha384, chacha20poly1305-prfsha512, aria128-md5, aria128-sha1, aria128-sha256, aria128-sha384, aria128-sha512, aria192-md5, aria192-sha1, aria192-sha256, aria192-sha384, aria192-sha512, aria256-md5, aria256-sha1, aria256-sha256, aria256-sha384, aria256-sha512, seed-md5, seed-sha1, seed-sha256, seed-sha384, seed-sha512
  add_route  = lookup(var.vpnipsec_phase1, "add_route ", null ) # Valid values: disable, enable
  add_gw_route  = lookup(var.vpnipsec_phase1, "add_gw_route ", null ) # Valid values: enable, disable
  psksecret  = lookup(var.vpnipsec_phase1, "psksecret ", null )
  psksecret_remote  = lookup(var.vpnipsec_phase1, "psksecret_remote ", null )
  keepalive  = lookup(var.vpnipsec_phase1, "keepalive ", null )
  distance  = lookup(var.vpnipsec_phase1, "distance ", null )
  priority  = lookup(var.vpnipsec_phase1, "priority ", null )
  localid  = lookup(var.vpnipsec_phase1, "localid ", null )
  localid_type  = lookup(var.vpnipsec_phase1, "localid_type ", null ) # Valid values: auto, fqdn, user-fqdn, keyid, address, asn1dn
  auto_negotiate  = lookup(var.vpnipsec_phase1, "auto_negotiate ", null ) # Valid values: enable, disable
  negotiate_timeout  = lookup(var.vpnipsec_phase1, "negotiate_timeout ", null )
  fragmentation  = lookup(var.vpnipsec_phase1, "fragmentation ", null ) # Valid values: enable, disable
  dpd  = lookup(var.vpnipsec_phase1, "dpd ", null ) # Valid values: disable, on-idle, on-demand
  dpd_retrycount  = lookup(var.vpnipsec_phase1, "dpd_retrycount ", null )
  dpd_retryinterval  = lookup(var.vpnipsec_phase1, "dpd_retryinterval ", null )
  forticlient_enforcement  = lookup(var.vpnipsec_phase1, "forticlient_enforcement ", null ) # Valid values: enable, disable
  comments  = lookup(var.vpnipsec_phase1, "comments ", null )
  npu_offload  = lookup(var.vpnipsec_phase1, "npu_offload ", null ) # Valid values: enable, disable
  send_cert_chain  = lookup(var.vpnipsec_phase1, "send_cert_chain ", null ) # Valid values: enable, disable
  dhgrp  = lookup(var.vpnipsec_phase1, "dhgrp ", null ) # Valid values: 1, 2, 5, 14, 15, 16, 17, 18, 19, 20, 21, 27, 28, 29, 30, 31, 32
  suite_b  = lookup(var.vpnipsec_phase1, "suite_b ", null ) # Valid values: disable, suite-b-gcm-128, suite-b-gcm-256
  eap  = lookup(var.vpnipsec_phase1, "eap ", null ) # Valid values: enable, disable
  eap_identity  = lookup(var.vpnipsec_phase1, "eap_identity ", null ) # Valid values: use-id-payload, send-request
  eap_exclude_peergrp  = lookup(var.vpnipsec_phase1, "eap_exclude_peergrp ", null )
  acct_verify  = lookup(var.vpnipsec_phase1, "acct_verify ", null ) # Valid values: enable, disable
  ppk  = lookup(var.vpnipsec_phase1, "ppk ", null ) # Valid values: disable, allow, require
  ppk_secret  = lookup(var.vpnipsec_phase1, "ppk_secret ", null )
  ppk_identity  = lookup(var.vpnipsec_phase1, "ppk_identity ", null )
  wizard_type  = lookup(var.vpnipsec_phase1, "wizard_type ", null )
  xauthtype  = lookup(var.vpnipsec_phase1, "xauthtype ", null ) # Valid values: disable, client, pap, chap, auto
  reauth  = lookup(var.vpnipsec_phase1, "reauth ", null ) # Valid values: disable, enable
  authusr  = lookup(var.vpnipsec_phase1, "authusr ", null )
  authpasswd  = lookup(var.vpnipsec_phase1, "authpasswd ", null )
  group_authentication  = lookup(var.vpnipsec_phase1, "group_authentication ", null ) # Valid values: enable, disable
  group_authentication_secret  = lookup(var.vpnipsec_phase1, "group_authentication_secret ", null )
  authusrgrp  = lookup(var.vpnipsec_phase1, "authusrgrp ", null )
  mesh_selector_type  = lookup(var.vpnipsec_phase1, "mesh_selector_type ", null ) # Valid values: disable, subnet, host
  idle_timeout  = lookup(var.vpnipsec_phase1, "idle_timeout ", null ) # Valid values: enable, disable
  idle_timeoutinterval  = lookup(var.vpnipsec_phase1, "idle_timeoutinterval ", null )
  ha_sync_esp_seqno  = lookup(var.vpnipsec_phase1, "ha_sync_esp_seqno ", null ) # Valid values: enable, disable
  inbound_dscp_copy  = lookup(var.vpnipsec_phase1, "inbound_dscp_copy ", null ) # Valid values: enable, disable
  nattraversal  = lookup(var.vpnipsec_phase1, "nattraversal ", null ) # Valid values: enable, disable, forced
  esn  = lookup(var.vpnipsec_phase1, "esn ", null ) # Valid values: require, allow, disable
  fragmentation_mtu  = lookup(var.vpnipsec_phase1, "fragmentation_mtu ", null )
  childless_ike  = lookup(var.vpnipsec_phase1, "childless_ike ", null ) # Valid values: enable, disable
  rekey  = lookup(var.vpnipsec_phase1, "rekey ", null ) # Valid values: enable, disable
  digital_signature_auth  = lookup(var.vpnipsec_phase1, "digital_signature_auth ", null ) # Valid values: enable, disable
  signature_hash_alg  = lookup(var.vpnipsec_phase1, "signature_hash_alg ", null ) # Valid values: sha1, sha2-256, sha2-384, sha2-512
  rsa_signature_format  = lookup(var.vpnipsec_phase1, "rsa_signature_format ", null ) # Valid values: pkcs1, pss
  enforce_unique_id  = lookup(var.vpnipsec_phase1, "enforce_unique_id ", null ) # Valid values: disable, keep-new, keep-old
  cert_id_validation  = lookup(var.vpnipsec_phase1, "cert_id_validation ", null ) # Valid values: enable, disable
  fec_egress  = lookup(var.vpnipsec_phase1, "fec_egress ", null ) # Valid values: enable, disable
  fec_send_timeout  = lookup(var.vpnipsec_phase1, "fec_send_timeout ", null )
  fec_base  = lookup(var.vpnipsec_phase1, "fec_base ", null )
  fec_codec  = lookup(var.vpnipsec_phase1, "fec_codec ", null )
  fec_redundant  = lookup(var.vpnipsec_phase1, "fec_redundant ", null )
  fec_ingress  = lookup(var.vpnipsec_phase1, "fec_ingress ", null ) # Valid values: enable, disable
  fec_receive_timeout  = lookup(var.vpnipsec_phase1, "fec_receive_timeout ", null )
  fec_health_check  = lookup(var.vpnipsec_phase1, "fec_health_check ", null )
  fec_mapping_profile  = lookup(var.vpnipsec_phase1, "fec_mapping_profile ", null )
  network_overlay  = lookup(var.vpnipsec_phase1, "network_overlay ", null ) # Valid values: disable, enable
  network_id  = lookup(var.vpnipsec_phase1, "network_id ", null )
  loopback_asymroute  = lookup(var.vpnipsec_phase1, "loopback_asymroute ", null ) # Valid values: enable, disable
  dynamic_sort_subtable  = lookup(var.vpnipsec_phase1, "dynamic_sort_subtable ", null )
  vdomparam  = lookup(var.vpnipsec_phase1, "vdomparam ", null )
}
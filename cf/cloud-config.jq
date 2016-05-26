{
  "vm_extensions": [
    {
      "name": "cf/haproxy",
      "cloud_properties": {
        "security_groups": [
          $cf_stack.HaproxySecurityGroupId,
          $cf_stack.TrustedPeerSecurityGroupId,
          $bosh_stack.InstanceSecurityGroupId,
          $infra_stack.GatewaySecurityGroupId
        ]
      }
    },
    {
      "name": "cf/doppler",
      "cloud_properties": {
        "security_groups": [
          $cf_stack.DopplerSecurityGroupId,
          $cf_stack.TrustedPeerSecurityGroupId,
          $bosh_stack.InstanceSecurityGroupId,
          $infra_stack.GatewaySecurityGroupId
        ]
      }
    },
    {
      "name": "cf/trusted-peer",
      "cloud_properties": {
        "security_groups": [
          $cf_stack.TrustedPeerSecurityGroupId,
          $bosh_stack.InstanceSecurityGroupId,
          $infra_stack.GatewaySecurityGroupId
        ]
      }
    }
  ]
}

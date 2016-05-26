{
  "AWSTemplateFormatVersion": "2010-09-09",
  "Resources": {
    "HaProxyEip1": {
      "Type": "AWS::EC2::EIP",
      "Properties": {
        "Domain": "vpc"
      }
    },
    "HaproxySecurityGroup": {
      "Type": "AWS::EC2::SecurityGroup",
      "Properties": {
        "GroupDescription": {
          "Fn::Join": [
            "/",
            [
              {
                "Ref": "AWS::StackName"
              },
              "haproxy"
            ]
          ]
        },
        "SecurityGroupIngress": ($env.management_cidrs | split(",") | map([
          {
            "CidrIp": .,
            "IpProtocol": "tcp",
            "FromPort": "80",
            "ToPort": "80"
          },
          {
            "CidrIp": .,
            "IpProtocol": "tcp",
            "FromPort": "443",
            "ToPort": "443"
          },
          {
            "CidrIp": .,
            "IpProtocol": "tcp",
            "FromPort": "4443",
            "ToPort": "4443"
          },
          {
            "CidrIp": .,
            "IpProtocol": "icmp",
            "FromPort": "-1",
            "ToPort": "-1"
          }
        ]) | add),
        "VpcId": $infra_stack.VpcId
      }
    },
    "TrustedPeerSecurityGroup": {
      "Type": "AWS::EC2::SecurityGroup",
      "Properties": {
        "GroupDescription": {
          "Fn::Join": [
            "/",
            [
              {
                "Ref": "AWS::StackName"
              },
              "trusted-peer"
            ]
          ]
        },
        "VpcId": $infra_stack.VpcId
      }
    },
    "TrustedPeerSecurityGroupEgress0": {
      "Type": "AWS::EC2::SecurityGroupIngress",
      "Properties": {
        "FromPort": "-1",
        "GroupId": {
          "Ref": "TrustedPeerSecurityGroup"
        },
        "IpProtocol": "-1",
        "SourceSecurityGroupId": {
          "Ref": "TrustedPeerSecurityGroup"
        },
        "ToPort": "-1"
      }
    },
    "Route53HaProxy": {
      "Type": "AWS::Route53::RecordSet",
      "Properties": {
        "HostedZoneName": ($config_settings.fqdn_zone + "."),
        "Name": ("*." + $config_settings.system_domain + "."),
        "ResourceRecords": [
          {
            "Ref": "HaProxyEip1"
          }
        ],
        "TTL": "300",
        "Type": "A",
      }
    }
  }
}

{
  "AWSTemplateFormatVersion": "2010-09-09",
  "Mappings": {
    "RegionMap": {
      "ap-northeast-1": {
        "hvm": "ami-29160d47"
      },
      "ap-northeast-2": {
        "hvm": "ami-cf32faa1"
      },
      "ap-southeast-1": {
        "hvm": "ami-1ddc0b7e"
      },
      "ap-southeast-2": {
        "hvm": "ami-0c95b86f"
      },
      "eu-central-1": {
        "hvm": "ami-d3c022bc"
      },
      "eu-west-1": {
        "hvm": "ami-b0ac25c3"
      },
      "sa-east-1": {
        "hvm": "ami-fb890097"
      },
      "us-east-1": {
        "hvm": "ami-f5f41398"
      },
      "us-west-1": {
        "hvm": "ami-6e84fa0e"
      },
      "us-west-2": {
        "hvm": "ami-d0f506b0"
      }
    }
  },
  "Resources": (
    {
      "Vpc": {
        "Type": "AWS::EC2::VPC",
          "Properties": {
          "CidrBlock": "10.0.0.0/16",
          "Tags": [
            {
              "Key": "director",
              "Value": $env.name
            },
            {
              "Key": "deployment",
              "Value": "infra"
            },
            {
              "Key": "Name",
              "Value": $env.name
            }
          ]
        }
      },
      "Dhcp": {
        "Type": "AWS::EC2::DHCPOptions",
        "Properties": {
          "DomainNameServers": [
            "169.254.169.253"
          ]
        }
      },

      "VpcDhcp": { 
        "Type": "AWS::EC2::VPCDHCPOptionsAssociation",
        "Properties": {
          "DhcpOptionsId": {
            "Ref": "Dhcp"
          },
          "VpcId": {
            "Ref": "Vpc"
          }
        }
      },

      "InternetGateway": {
        "Type": "AWS::EC2::InternetGateway"
      },
      "InternetGatewayAttachment": {
        "Type": "AWS::EC2::VPCGatewayAttachment",
        "Properties": {
          "InternetGatewayId": {
            "Ref": "InternetGateway"
          },
          "VpcId": {
            "Ref": "Vpc"
          }
        }
      },

      "NetworkAclDefault": {
        "Type": "AWS::EC2::NetworkAcl",
        "Properties": {
          "VpcId": {
            "Ref": "Vpc"
          }
        }
      },
      "NetworkAclDefaultEgress0": {
        "Type": "AWS::EC2::NetworkAclEntry",
        "Properties": {
          "CidrBlock": "0.0.0.0/0",
          "Egress": true,
          "NetworkAclId": {
            "Ref": "NetworkAclDefault"
          },
          "Protocol": -1,
          "RuleAction": "allow",
          "RuleNumber": 100
        }
      },
      "NetworkAclDefaultIngress0": {
        "Type": "AWS::EC2::NetworkAclEntry",
        "Properties": {
          "CidrBlock": "0.0.0.0/0",
          "Egress": false,
          "NetworkAclId": {
            "Ref": "NetworkAclDefault"
          },
          "Protocol": -1,
          "RuleAction": "allow",
          "RuleNumber": 100
        }
      },

      "GatewaySecurityGroup": {
        "Type": "AWS::EC2::SecurityGroup",
        "Properties": {
          "GroupDescription": {
            "Fn::Join": [
              "/",
              [
                {
                  "Ref": "AWS::StackName"
                },
                "gateway"
              ]
            ]
          },
          "SecurityGroupEgress": [],
          "SecurityGroupIngress": [],
          "VpcId": {
            "Ref": "Vpc"
          }
        }
      },
      "GatewaySecurityGroupEgress0": {
        "Type": "AWS::EC2::SecurityGroupEgress",
        "Properties": {
          "GroupId": {
            "Ref": "GatewaySecurityGroup"
          },
          "IpProtocol": "-1",
          "DestinationSecurityGroupId": {
            "Ref": "GatewayInstanceSecurityGroup"
          }
        }
      },

      "GatewayInstanceSecurityGroup": {
        "Type": "AWS::EC2::SecurityGroup",
        "Properties": {
          "GroupDescription": {
            "Fn::Join": [
              "/",
              [
                {
                  "Ref": "AWS::StackName"
                },
                "gateway-instance"
              ]
            ]
          },
          "SecurityGroupEgress": [
            {
              "CidrIp": "0.0.0.0/0",
              "IpProtocol": "-1"
            }
          ],
          "VpcId": {
            "Ref": "Vpc"
          }
        }
      },
      "GatewayInstanceSecurityGroupIngress0": {
        "Type": "AWS::EC2::SecurityGroupIngress",
        "Properties": {
          "GroupId": {
            "Ref": "GatewayInstanceSecurityGroup"
          },
          "IpProtocol": "-1",
          "SourceSecurityGroupId": {
            "Ref": "GatewaySecurityGroup"
          }
        }
      },
  
      "Z1GatewayInstance": {
        "Type": "AWS::EC2::Instance",
        "Properties": {
          "AvailabilityZone": {
            "Fn::Select": [
              0,
              {
                "Fn::GetAZs": {
                  "Ref": "AWS::Region"
                }
              }
            ]
          },
          "ImageId": {
            "Fn::FindInMap": [
              "RegionMap",
              {
                "Ref": "AWS::Region"
              },
              "hvm"
            ]
          },
          "InstanceType": "t2.micro",
          "KeyName": $env.ssh_key_name,
          "SourceDestCheck": "false",
          "NetworkInterfaces": [
            {
              "DeviceIndex": "0",
              "AssociatePublicIpAddress": true,
              "GroupSet": [
                {
                  "Ref": "GatewayInstanceSecurityGroup"
                }
              ],
              "PrivateIpAddress": "10.0.0.4",
              "SubnetId": {
                "Ref": "SubnetZ1Public"
              }
            }
          ],
          "UserData": {
            "Fn::Base64": {
              "Fn::Join": [
                "\n",
                [
                  "#!/bin/bash",
                  "set -ex",
                  "sysctl -w net.ipv4.ip_forward=1 | sudo tee -a /etc/sysctl.conf",
                  "sysctl -w net.ipv4.conf.eth0.send_redirects=0 | sudo tee -a /etc/sysctl.conf",
                  "iptables -t nat -A POSTROUTING -s 10.0.0.0/21 -d 0/0 -j MASQUERADE -m comment --comment \"" + $env.name + " -> internet\"",
                  "service iptables save"
                ]
              ]
            }
          },
          "Tags": [
            {
              "Key": "director",
              "Value": $env.name
            },
            {
              "Key": "deployment",
              "Value": "infra"
            },
            {
              "Key": "Name",
              "Value": "gateway"
            }
          ]
        }
      }
    } * (
      [
        {
          "index": "1",
          "public": "10.0.0.0/24",
          "private": "10.0.4.0/24"
        },
        {
          "index": "2",
          "public": "10.0.1.0/24",
          "private": "10.0.5.0/24"
        }
      ] | map({
        ("SubnetZ" + .index + "Public"): {
          "Type": "AWS::EC2::Subnet",
          "Properties": {
            "AvailabilityZone": { "Fn::Select": [ .index | tonumber - 1, { "Fn::GetAZs": { "Ref": "AWS::Region" } } ] },
            "CidrBlock": .public,
            "VpcId": {
              "Ref": "Vpc"
            },
            "Tags": [
              {
                "Key": "director",
                "Value": $env.name
              },
              {
                "Key": "deployment",
                "Value": "infra"
              },
              {
                "Key": "Name",
                "Value": ("public/z" + .index)
              }
            ]
          }
        },
        ("SubnetZ" + .index + "PublicNetworkAclDefault"): {
          "Type": "AWS::EC2::SubnetNetworkAclAssociation",
          "Properties": {
            "NetworkAclId": {
              "Ref": "NetworkAclDefault"
            },
            "SubnetId": {
              "Ref": ("SubnetZ" + .index + "Public")
            }
          }
        },
        ("SubnetZ" + .index + "PublicRoutetable"): {
          "Type": "AWS::EC2::RouteTable",
          "Properties": {
            "VpcId": {
              "Ref": "Vpc"
            },
            "Tags": [
              {
                "Key": "director",
                "Value": $env.name
              },
              {
                "Key": "deployment",
                "Value": "infra"
              },
              {
                "Key": "Name",
                "Value": ("private/z" + .index)
              }
            ]
          }
        },
        ("SubnetZ" + .index + "PublicRoutetableRouteInternet"): {
          "Type": "AWS::EC2::Route",
          "DependsOn": [
            "InternetGatewayAttachment"
          ],
          "Properties": {
            "RouteTableId": {
              "Ref": ("SubnetZ" + .index + "PublicRoutetable")
            },
            "DestinationCidrBlock": "0.0.0.0/0",
            "GatewayId": {
              "Ref": "InternetGateway"
            }
          }
        },
        ("SubnetZ" + .index + "PublicRoutetableAssoc"): {
          "Type": "AWS::EC2::SubnetRouteTableAssociation",
          "Properties": {
            "RouteTableId": {
              "Ref": ("SubnetZ" + .index + "PublicRoutetable")
            },
            "SubnetId": {
              "Ref": ("SubnetZ" + .index + "Public")
            }
          }
        },

        ("SubnetZ" + .index + "Private"): {
          "Type": "AWS::EC2::Subnet",
          "Properties": {
            "AvailabilityZone": { "Fn::Select": [ .index | tonumber - 1, { "Fn::GetAZs": { "Ref": "AWS::Region" } } ] },
            "CidrBlock": .private,
            "VpcId": {
              "Ref": "Vpc"
            },
            "Tags": [
              {
                "Key": "director",
                "Value": $env.name
              },
              {
                "Key": "deployment",
                "Value": "infra"
              },
              {
                "Key": "Name",
                "Value": ("private/z" + .index)
              }
            ]
          }
        },
        ("SubnetZ" + .index + "PrivateNetworkAclDefault"): {
          "Type": "AWS::EC2::SubnetNetworkAclAssociation",
          "Properties": {
            "NetworkAclId": {
              "Ref": "NetworkAclDefault"
            },
            "SubnetId": {
              "Ref": ("SubnetZ" + .index + "Private")
            }
          }
        },
        ("SubnetZ" + .index + "PrivateRoutetable"): {
          "Type": "AWS::EC2::RouteTable",
          "Properties": {
            "VpcId": {
              "Ref": "Vpc"
            },
            "Tags": [
              {
                "Key": "director",
                "Value": $env.name
              },
              {
                "Key": "deployment",
                "Value": "infra"
              },
              {
                "Key": "Name",
                "Value": ("private/z" + .index)
              }
            ]
          }
        },
        ("SubnetZ" + .index + "PrivateRoutetableRouteInternet"): {
            "Type": "AWS::EC2::Route",
            "Properties": {
                "RouteTableId": {
                  "Ref": ("SubnetZ" + .index + "PrivateRoutetable")
                },
                "DestinationCidrBlock": "0.0.0.0/0",
                "InstanceId": {
                  "Ref": "Z1GatewayInstance"
                }
            }
        },
        ("SubnetZ" + .index + "PrivateRoutetableAssoc"): {
          "Type": "AWS::EC2::SubnetRouteTableAssociation",
          "Properties": {
            "RouteTableId": {
              "Ref": ("SubnetZ" + .index + "PrivateRoutetable")
            },
            "SubnetId": {
              "Ref": ("SubnetZ" + .index + "Private")
            }
          }
        }
      }) | add
  )),
  "Outputs": {
    "Region": {
      "Value": { "Ref": "AWS::Region" }
    },
    "NameZ1": {
      "Value": { "Fn::Select": [ 0, { "Fn::GetAZs": { "Ref": "AWS::Region" } } ] }
    },
    "NameZ2": {
      "Value": { "Fn::Select": [ 1, { "Fn::GetAZs": { "Ref": "AWS::Region" } } ] }
    }
  }
}

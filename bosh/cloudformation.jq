{
  "AWSTemplateFormatVersion": "2010-09-09",
  "Resources": {
    "PublicEip": {
      "Type": "AWS::EC2::EIP",
      "Properties": {
        "Domain": "vpc"
      }
    },
    "InstanceSecurityGroup": {
      "Type": "AWS::EC2::SecurityGroup",
      "Properties": {
        "GroupDescription": {
          "Fn::Join": [
            "/",
            [
              {
                "Ref": "AWS::StackName"
              },
              "agent"
            ]
          ]
        },
        "VpcId": $infra_stack.VpcId
      }
    },
    "InstanceSecurityGroupIngress0": {
      "Type": "AWS::EC2::SecurityGroupIngress",
      "Properties": {
        "FromPort": "22",
        "GroupId": {
          "Ref": "InstanceSecurityGroup"
        },
        "IpProtocol": "tcp",
        "SourceSecurityGroupId": {
          "Ref": "DirectorSecurityGroup"
        },
        "ToPort": "22"
      }
    },
    "InstanceSecurityGroupIngress1": {
      "Type": "AWS::EC2::SecurityGroupIngress",
      "Properties": {
        "FromPort": "6868",
        "GroupId": {
          "Ref": "InstanceSecurityGroup"
        },
        "IpProtocol": "tcp",
        "SourceSecurityGroupId": {
          "Ref": "DirectorSecurityGroup"
        },
        "ToPort": "6868"
      }
    },
    "InstanceSecurityGroupEgress0": {
      "Type": "AWS::EC2::SecurityGroupEgress",
      "Properties": {
        "FromPort": "4222",
        "GroupId": {
          "Ref": "InstanceSecurityGroup"
        },
        "IpProtocol": "tcp",
        "DestinationSecurityGroupId": {
          "Ref": "DirectorSecurityGroup"
        },
        "ToPort": "4222"
      }
    },
    "InstanceSecurityGroupEgress1": {
      "Type": "AWS::EC2::SecurityGroupEgress",
      "Properties": {
        "FromPort": "25250",
        "GroupId": {
          "Ref": "InstanceSecurityGroup"
        },
        "IpProtocol": "tcp",
        "DestinationSecurityGroupId": {
          "Ref": "DirectorSecurityGroup"
        },
        "ToPort": "25250"
      }
    },
    "InstanceSecurityGroupEgress2": {
      "Type": "AWS::EC2::SecurityGroupEgress",
      "Properties": {
        "FromPort": "25777",
        "GroupId": {
          "Ref": "InstanceSecurityGroup"
        },
        "IpProtocol": "tcp",
        "DestinationSecurityGroupId": {
          "Ref": "DirectorSecurityGroup"
        },
        "ToPort": "25777"
      }
    },
    
    "DirectorSecurityGroup": {
      "Type": "AWS::EC2::SecurityGroup",
      "Properties": {
        "GroupDescription": {
          "Fn::Join": [
            "/",
            [
              {
                "Ref": "AWS::StackName"
              },
              "director"
            ]
          ]
        },
        "SecurityGroupEgress": [
          {
            "CidrIp": "0.0.0.0/0",
            "IpProtocol": "-1"
          }
        ],
        "SecurityGroupIngress": ($env.management_cidrs | split(",") | map([
          {
            "CidrIp": .,
            "FromPort": "22",
            "IpProtocol": "tcp",
            "ToPort": "22"
          },
          {
            "CidrIp": .,
            "FromPort": "25555",
            "IpProtocol": "tcp",
            "ToPort": "25555"
          },
          {
            "CidrIp": .,
            "FromPort": "6868",
            "IpProtocol": "tcp",
            "ToPort": "6868"
          }
        ]) | add),
        "VpcId": $infra_stack.VpcId
      }
    },
    "DirectorSecurityGroupEgress0": {
      "Type": "AWS::EC2::SecurityGroupEgress",
      "Properties": {
        "FromPort": "6868",
        "GroupId": {
          "Ref": "DirectorSecurityGroup"
        },
        "IpProtocol": "tcp",
        "DestinationSecurityGroupId": {
          "Ref": "InstanceSecurityGroup"
        },
        "ToPort": "6868"
      }
    },
    "DirectorSecurityGroupIngress0": {
      "Type": "AWS::EC2::SecurityGroupIngress",
      "Properties": {
        "FromPort": "4222",
        "GroupId": {
          "Ref": "DirectorSecurityGroup"
        },
        "IpProtocol": "tcp",
        "SourceSecurityGroupId": {
          "Ref": "InstanceSecurityGroup"
        },
        "ToPort": "4222"
      }
    },
    "DirectorSecurityGroupIngress1": {
      "Type": "AWS::EC2::SecurityGroupIngress",
      "Properties": {
        "FromPort": "25250",
        "GroupId": {
          "Ref": "DirectorSecurityGroup"
        },
        "IpProtocol": "tcp",
        "SourceSecurityGroupId": {
          "Ref": "InstanceSecurityGroup"
        },
        "ToPort": "25250"
      }
    },
    "DirectorSecurityGroupIngress2": {
      "Type": "AWS::EC2::SecurityGroupIngress",
      "Properties": {
        "FromPort": "25777",
        "GroupId": {
          "Ref": "DirectorSecurityGroup"
        },
        "IpProtocol": "tcp",
        "SourceSecurityGroupId": {
          "Ref": "InstanceSecurityGroup"
        },
        "ToPort": "25777"
      }
    },
    "DirectorSecurityGroupIngress3": {
      "Type": "AWS::EC2::SecurityGroupIngress",
      "Properties": {
        "FromPort": "22",
        "GroupId": {
          "Ref": "DirectorSecurityGroup"
        },
        "IpProtocol": "tcp",
        "SourceSecurityGroupId": {
          "Ref": "InstanceSecurityGroup"
        },
        "ToPort": "22"
      }
    },
    "DirectorRole": {
      "Type": "AWS::IAM::Role",
      "Properties": {
        "AssumeRolePolicyDocument": {
          "Statement": [
            {
              "Action": [
                "sts:AssumeRole"
              ],
              "Effect": "Allow",
              "Principal": {
                "Service": [
                  "ec2.amazonaws.com"
                ]
              }
            }
          ],
          "Version": "2012-10-17"
        },
        "Path": ( "/" + $env.name + "/iam-role/bosh/director/" ),
        "Policies": [
          {
            "PolicyName": "default",
            "PolicyDocument": {
              "Statement": [
                {
                  "Action": [
                    "ec2:AssociateAddress",
                    "ec2:AttachVolume",
                    "ec2:CreateVolume",
                    "ec2:DeleteSnapshot",
                    "ec2:DeleteVolume",
                    "ec2:DescribeAddresses",
                    "ec2:DescribeImages",
                    "ec2:DescribeInstances",
                    "ec2:DescribeRegions",
                    "ec2:DescribeSecurityGroups",
                    "ec2:DescribeSnapshots",
                    "ec2:DescribeSubnets",
                    "ec2:DescribeVolumes",
                    "ec2:DetachVolume",
                    "ec2:CreateSnapshot",
                    "ec2:CreateTags",
                    "ec2:RunInstances",
                    "ec2:TerminateInstances",
                    "ec2:RegisterImage",
                    "ec2:DeregisterImage"
                  ],
                  "Effect": "Allow",
                  "Resource": "*"
                },
                {
                  "Effect": "Allow",
                  "Action": "elasticloadbalancing:*",
                  "Resource": "*"
                }
              ],
              "Version": "2012-10-17"
            }
          }
        ]
      }
    },
    "DirectorInstanceProfile": {
      "Type": "AWS::IAM::InstanceProfile",
      "Properties": {
        "Path": ( "/" + $env.name + "/iam-instance-profile/bosh/director/" ),
        "Roles": [
          {
            "Ref": "DirectorRole"
          }
        ]
      }
    }
  }
}

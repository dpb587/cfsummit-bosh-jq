{
  "azs": [
    {
      "name": "a",
      "cloud_properties": {
        "availability_zone": $infra_stack_outputs.NameZ1
      }
    },
    {
      "name": "b",
      "cloud_properties": {
        "availability_zone": $infra_stack_outputs.NameZ2
      }
    }
  ],
  "compilation": {
    "az": "b",
    "network": "private",
    "reuse_compilation_vms": true,
    "vm_type": "c3_large",
    "workers": 8
  },
  "disk_types": [
    {
      "name": "standard_4",
      "disk_size": 4096,
      "cloud_properties": {
        "type": "standard"
      }
    },
    {
      "name": "standard_8",
      "disk_size": 8192,
      "cloud_properties": {
        "type": "standard"
      }
    },
    {
      "name": "standard_16",
      "disk_size": 16384,
      "cloud_properties": {
        "type": "standard"
      }
    },
    {
      "name": "standard_32",
      "disk_size": 32768,
      "cloud_properties": {
        "type": "standard"
      }
    },
    {
      "name": "standard_64",
      "disk_size": 65536,
      "cloud_properties": {
        "type": "standard"
      }
    },
    {
      "name": "standard_128",
      "disk_size": 131072,
      "cloud_properties": {
        "type": "standard"
      }
    },
    {
      "name": "standard_256",
      "disk_size": 262144,
      "cloud_properties": {
        "type": "standard"
      }
    },
    {
      "name": "standard_512",
      "disk_size": 524288,
      "cloud_properties": {
        "type": "standard"
      }
    },
    {
      "name": "standard_1024",
      "disk_size": 1048576,
      "cloud_properties": {
        "type": "standard"
      }
    },
    {
      "name": "standard_2048",
      "disk_size": 2097152,
      "cloud_properties": {
        "type": "standard"
      }
    },
    {
      "name": "gp2_4",
      "disk_size": 4096,
      "cloud_properties": {
        "type": "gp2"
      }
    },
    {
      "name": "gp2_8",
      "disk_size": 8192,
      "cloud_properties": {
        "type": "gp2"
      }
    },
    {
      "name": "gp2_16",
      "disk_size": 16384,
      "cloud_properties": {
        "type": "gp2"
      }
    },
    {
      "name": "gp2_32",
      "disk_size": 32768,
      "cloud_properties": {
        "type": "gp2"
      }
    },
    {
      "name": "gp2_64",
      "disk_size": 65536,
      "cloud_properties": {
        "type": "gp2"
      }
    },
    {
      "name": "gp2_128",
      "disk_size": 131072,
      "cloud_properties": {
        "type": "gp2"
      }
    },
    {
      "name": "gp2_256",
      "disk_size": 262144,
      "cloud_properties": {
        "type": "gp2"
      }
    },
    {
      "name": "gp2_512",
      "disk_size": 524288,
      "cloud_properties": {
        "type": "gp2"
      }
    },
    {
      "name": "gp2_1024",
      "disk_size": 1048576,
      "cloud_properties": {
        "type": "gp2"
      }
    },
    {
      "name": "gp2_2048",
      "disk_size": 2097152,
      "cloud_properties": {
        "type": "gp2"
      }
    }
  ],
  "vm_types": [
    {
      "name": "c1_medium",
      "cloud_properties": {
        "instance_type": "c1.medium"
      }
    },
    {
      "name": "c1_xlarge",
      "cloud_properties": {
        "instance_type": "c1.xlarge"
      }
    },
    {
      "name": "c3_2xlarge",
      "cloud_properties": {
        "instance_type": "c3.2xlarge"
      }
    },
    {
      "name": "c3_4xlarge",
      "cloud_properties": {
        "instance_type": "c3.4xlarge"
      }
    },
    {
      "name": "c3_8xlarge",
      "cloud_properties": {
        "instance_type": "c3.8xlarge"
      }
    },
    {
      "name": "c3_large",
      "cloud_properties": {
        "instance_type": "c3.large"
      }
    },
    {
      "name": "c3_xlarge",
      "cloud_properties": {
        "instance_type": "c3.xlarge"
      }
    },
    {
      "name": "c4_2xlarge",
      "cloud_properties": {
        "instance_type": "c4.2xlarge",
        "ephemeral_disk": {
          "size": 16384
        }
      }
    },
    {
      "name": "c4_4xlarge",
      "cloud_properties": {
        "instance_type": "c4.4xlarge",
        "ephemeral_disk": {
          "size": 16384
        }
      }
    },
    {
      "name": "c4_8xlarge",
      "cloud_properties": {
        "instance_type": "c4.8xlarge",
        "ephemeral_disk": {
          "size": 16384
        }
      }
    },
    {
      "name": "c4_large",
      "cloud_properties": {
        "instance_type": "c4.large",
        "ephemeral_disk": {
          "size": 16384
        }
      }
    },
    {
      "name": "c4_xlarge",
      "cloud_properties": {
        "instance_type": "c4.xlarge",
        "ephemeral_disk": {
          "size": 16384
        }
      }
    },
    {
      "name": "cc1_4xlarge",
      "cloud_properties": {
        "instance_type": "cc1.4xlarge",
        "ephemeral_disk": {
          "size": 16384
        }
      }
    },
    {
      "name": "cc2_8xlarge",
      "cloud_properties": {
        "instance_type": "cc2.8xlarge"
      }
    },
    {
      "name": "cg1_4xlarge",
      "cloud_properties": {
        "instance_type": "cg1.4xlarge"
      }
    },
    {
      "name": "cr1_8xlarge",
      "cloud_properties": {
        "instance_type": "cr1.8xlarge"
      }
    },
    {
      "name": "d2_2xlarge",
      "cloud_properties": {
        "instance_type": "d2.2xlarge"
      }
    },
    {
      "name": "d2_4xlarge",
      "cloud_properties": {
        "instance_type": "d2.4xlarge"
      }
    },
    {
      "name": "d2_8xlarge",
      "cloud_properties": {
        "instance_type": "d2.8xlarge"
      }
    },
    {
      "name": "d2_xlarge",
      "cloud_properties": {
        "instance_type": "d2.xlarge"
      }
    },
    {
      "name": "g2_2xlarge",
      "cloud_properties": {
        "instance_type": "g2.2xlarge"
      }
    },
    {
      "name": "g2_8xlarge",
      "cloud_properties": {
        "instance_type": "g2.8xlarge"
      }
    },
    {
      "name": "hi1_4xlarge",
      "cloud_properties": {
        "instance_type": "hi1.4xlarge"
      }
    },
    {
      "name": "hs1_8xlarge",
      "cloud_properties": {
        "instance_type": "hs1.8xlarge"
      }
    },
    {
      "name": "i2_2xlarge",
      "cloud_properties": {
        "instance_type": "i2.2xlarge"
      }
    },
    {
      "name": "i2_4xlarge",
      "cloud_properties": {
        "instance_type": "i2.4xlarge"
      }
    },
    {
      "name": "i2_8xlarge",
      "cloud_properties": {
        "instance_type": "i2.8xlarge"
      }
    },
    {
      "name": "i2_xlarge",
      "cloud_properties": {
        "instance_type": "i2.xlarge"
      }
    },
    {
      "name": "m1_large",
      "cloud_properties": {
        "instance_type": "m1.large"
      }
    },
    {
      "name": "m1_medium",
      "cloud_properties": {
        "instance_type": "m1.medium"
      }
    },
    {
      "name": "m1_small",
      "cloud_properties": {
        "instance_type": "m1.small"
      }
    },
    {
      "name": "m1_xlarge",
      "cloud_properties": {
        "instance_type": "m1.xlarge"
      }
    },
    {
      "name": "m2_2xlarge",
      "cloud_properties": {
        "instance_type": "m2.2xlarge"
      }
    },
    {
      "name": "m2_4xlarge",
      "cloud_properties": {
        "instance_type": "m2.4xlarge"
      }
    },
    {
      "name": "m2_xlarge",
      "cloud_properties": {
        "instance_type": "m2.xlarge"
      }
    },
    {
      "name": "m3_2xlarge",
      "cloud_properties": {
        "instance_type": "m3.2xlarge"
      }
    },
    {
      "name": "m3_large",
      "cloud_properties": {
        "instance_type": "m3.large"
      }
    },
    {
      "name": "m3_medium",
      "cloud_properties": {
        "instance_type": "m3.medium"
      }
    },
    {
      "name": "m3_xlarge",
      "cloud_properties": {
        "instance_type": "m3.xlarge"
      }
    },
    {
      "name": "m4_10xlarge",
      "cloud_properties": {
        "instance_type": "m4.10xlarge",
        "ephemeral_disk": {
          "size": 16384
        }
      }
    },
    {
      "name": "m4_2xlarge",
      "cloud_properties": {
        "instance_type": "m4.2xlarge",
        "ephemeral_disk": {
          "size": 16384
        }
      }
    },
    {
      "name": "m4_4xlarge",
      "cloud_properties": {
        "instance_type": "m4.4xlarge",
        "ephemeral_disk": {
          "size": 16384
        }
      }
    },
    {
      "name": "m4_large",
      "cloud_properties": {
        "instance_type": "m4.large",
        "ephemeral_disk": {
          "size": 16384
        }
      }
    },
    {
      "name": "m4_xlarge",
      "cloud_properties": {
        "instance_type": "m4.xlarge",
        "ephemeral_disk": {
          "size": 16384
        }
      }
    },
    {
      "name": "r3_2xlarge",
      "cloud_properties": {
        "instance_type": "r3.2xlarge"
      }
    },
    {
      "name": "r3_4xlarge",
      "cloud_properties": {
        "instance_type": "r3.4xlarge"
      }
    },
    {
      "name": "r3_8xlarge",
      "cloud_properties": {
        "instance_type": "r3.8xlarge"
      }
    },
    {
      "name": "r3_large",
      "cloud_properties": {
        "instance_type": "r3.large"
      }
    },
    {
      "name": "r3_xlarge",
      "cloud_properties": {
        "instance_type": "r3.xlarge"
      }
    },
    {
      "name": "t1_micro",
      "cloud_properties": {
        "instance_type": "t1.micro",
        "ephemeral_disk": {
          "size": 16384
        }
      }
    },
    {
      "name": "t2_large",
      "cloud_properties": {
        "instance_type": "t2.large",
        "ephemeral_disk": {
          "size": 16384
        }
      }
    },
    {
      "name": "t2_medium",
      "cloud_properties": {
        "instance_type": "t2.medium",
        "ephemeral_disk": {
          "size": 16384
        }
      }
    },
    {
      "name": "t2_micro",
      "cloud_properties": {
        "instance_type": "t2.micro",
        "ephemeral_disk": {
          "size": 16384
        }
      }
    },
    {
      "name": "t2_nano",
      "cloud_properties": {
        "instance_type": "t2.nano",
        "ephemeral_disk": {
          "size": 16384
        }
      }
    },
    {
      "name": "t2_small",
      "cloud_properties": {
        "instance_type": "t2.small",
        "ephemeral_disk": {
          "size": 16384
        }
      }
    }
  ],
  "networks": [
    {
      "name": "private",
      "type": "manual",
      "subnets": [
        {
          "range": "10.0.4.0/24",
          "az": "a",
          "gateway": "10.0.4.1",
          "static": [
            "10.0.4.2 - 10.0.4.31"
          ],
          "dns": [
            "169.254.169.253"
          ],
          "cloud_properties": {
            "subnet": $infra_stack.SubnetZ1PrivateId
          }
        },
        {
          "range": "10.0.5.0/24",
          "az": "b",
          "gateway": "10.0.5.1",
          "static": [
            "10.0.5.2 - 10.0.5.31"
          ],
          "dns": [
            "169.254.169.253"
          ],
          "cloud_properties": {
            "subnet": $infra_stack.SubnetZ2PrivateId
          }
        }
      ]
    },
    {
      "name": "public",
      "type": "manual",
      "subnets": [
        {
          "range": "10.0.0.0/24",
          "az": "a",
          "gateway": "10.0.0.1",
          "static": [
            "10.0.0.2 - 10.0.0.31"
          ],
          "dns": [
            "169.254.169.253"
          ],
          "cloud_properties": {
            "subnet": $infra_stack.SubnetZ1PublicId
          }
        },
        {
          "range": "10.0.1.0/24",
          "az": "b",
          "gateway": "10.0.1.1",
          "static": [
            "10.0.1.2 - 10.0.1.31"
          ],
          "dns": [
            "169.254.169.253"
          ],
          "cloud_properties": {
            "subnet": $infra_stack.SubnetZ2PublicId
          }
        }
      ]
    },
    {
      "name": "vip",
      "type": "vip"
    }
  ]
}

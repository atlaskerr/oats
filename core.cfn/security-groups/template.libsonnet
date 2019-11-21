local bastion = {
  Type: 'AWS::EC2::SecurityGroup',
  Properties: {
    GroupDescription: 'Security group for SSH bastion instances.',
    GroupName: 'bastion',
    VpcId: { Ref: 'VpcId' },
    SecurityGroupIngress: [
      // Allow SSH inbound traffic.
      {
        CidrIp: '0.0.0.0/0',
        FromPort: 22,
        ToPort: 22,
        IpProtocol: 'tcp',
      },
    ],
    SecurityGroupEgress: [
      // Allow outbound HTTP/S traffic to everywhere for updates and whatnot.
      {
        CidrIp: '0.0.0.0/0',
        FromPort: 80,
        ToPort: 80,
        IpProtocol: 'tcp',
      },
      {
        CidrIp: '0.0.0.0/0',
        FromPort: 443,
        ToPort: 443,
        IpProtocol: 'tcp',
      },
    ],
  },
};

local playground = {
  Type: 'AWS::EC2::SecurityGroup',
  Properties: {
    GroupDescription: 'Security group for instances accessed via bastion or vpn.',
    GroupName: 'all',
    VpcId: { Ref: 'VpcId' },
    SecurityGroupEgress: [
      // Allow outbound HTTP/HTTPS traffic.
      {
        CidrIp: '0.0.0.0/0',
        FromPort: 80,
        ToPort: 80,
        IpProtocol: 'tcp',
      },
      {
        CidrIp: '0.0.0.0/0',
        FromPort: 443,
        ToPort: 443,
        IpProtocol: 'tcp',
      },
    ],
  },
};

local vpn = {
  Type: 'AWS::EC2::SecurityGroup',
  Properties: {
    GroupDescription: 'Security group for VPN instances.',
    GroupName: 'vpn',
    VpcId: { Ref: 'VpcId' },
    SecurityGroupIngress: [
      // Allow SSH inbound traffic.
      {
        CidrIp: '0.0.0.0/0',
        FromPort: 22,
        ToPort: 22,
        IpProtocol: 'tcp',
      },
      // Allow inbound UDP traffic on port 1194.
      {
        CidrIp: '0.0.0.0/0',
        FromPort: 1194,
        ToPort: 1194,
        IpProtocol: 'udp',
      },
      // Allow inbound TCP traffic on port 943.
      {
        CidrIp: '0.0.0.0/0',
        FromPort: 943,
        ToPort: 943,
        IpProtocol: 'tcp',
      },
      // Allow inbound HTTPS traffic on port.
      {
        CidrIp: '0.0.0.0/0',
        FromPort: 443,
        ToPort: 443,
        IpProtocol: 'tcp',
      },
    ],
    SecurityGroupEgress: [
      // Allow outbound HTTP/HTTPS traffic.
      {
        CidrIp: '0.0.0.0/0',
        FromPort: 80,
        ToPort: 80,
        IpProtocol: 'tcp',
      },
      {
        CidrIp: '0.0.0.0/0',
        FromPort: 443,
        ToPort: 443,
        IpProtocol: 'tcp',
      },
    ],
  },
};

local asg = {
  Type: 'AWS::EC2::SecurityGroup',
  Properties: {
    GroupDescription: 'Security group for auto scaling playground instances.',
    GroupName: 'asg',
    VpcId: { Ref: 'VpcId' },
    SecurityGroupIngress: [],
    SecurityGroupEgress: [],
  },
};

local elb = {
  Type: 'AWS::EC2::SecurityGroup',
  Properties: {
    GroupDescription: 'Security group for ELB access.',
    GroupName: 'elb',
    VpcId: { Ref: 'VpcId' },
    SecurityGroupIngress: [],
    SecurityGroupEgress: [],
  },
};

local efs = {
  Type: 'AWS::EC2::SecurityGroup',
  Properties: {
    GroupDescription: 'Security group for EFS access.',
    GroupName: 'efs',
    VpcId: { Ref: 'VpcId' },
    SecurityGroupIngress: [],
    SecurityGroupEgress: [],
  },
};

{
  AWSTemplateFormatVersion: '2010-09-09',
  Description: 'Security Groups Template',
  Parameters: {
    VpcId: {
      Description: 'VPC ID to add security groups to.',
      Type: 'String',
    },
  },
  Resources: {
    SecurityGroupBastion: bastion,
    SecurityGroupVpn: vpn,
    SecurityGroupPlayground: playground,
    SecurityGroupAsg: asg,
    SecurityGroupElb: elb,
    SecurityGroupEfs: efs,

    // Ingress rules
    SecurityGroupIngressBastionPlayground: {
      Type: 'AWS::EC2::SecurityGroupIngress',
      Properties: {
        SourceSecurityGroupId: {
          'Fn::GetAtt': ['SecurityGroupBastion', 'GroupId'],
        },
        GroupId: { 'Fn::GetAtt': ['SecurityGroupPlayground', 'GroupId'] },
        FromPort: 22,
        ToPort: 22,
        IpProtocol: 'tcp',
      },
    },
    SecurityGroupIngressVpnPlayground: {
      Type: 'AWS::EC2::SecurityGroupIngress',
      Properties: {
        SourceSecurityGroupId: {
          'Fn::GetAtt': ['SecurityGroupVpn', 'GroupId'],
        },
        GroupId: { 'Fn::GetAtt': ['SecurityGroupPlayground', 'GroupId'] },
        FromPort: 22,
        ToPort: 22,
        IpProtocol: 'tcp',
      },
    },
    SecurityGroupIngressElbAsg: {
      Type: 'AWS::EC2::SecurityGroupIngress',
      Properties: {
        SourceSecurityGroupId: {
          'Fn::GetAtt': ['SecurityGroupElb', 'GroupId'],
        },
        GroupId: { 'Fn::GetAtt': ['SecurityGroupAsg', 'GroupId'] },
        FromPort: 22,
        ToPort: 22,
        IpProtocol: 'tcp',
      },
    },

    SecurityGroupIngressBastionElb: {
      Type: 'AWS::EC2::SecurityGroupIngress',
      Properties: {
        SourceSecurityGroupId: {
          'Fn::GetAtt': ['SecurityGroupBastion', 'GroupId'],
        },
        GroupId: { 'Fn::GetAtt': ['SecurityGroupElb', 'GroupId'] },
        FromPort: 22,
        ToPort: 22,
        IpProtocol: 'tcp',
      },
    },

    SecurityGroupIngressVpnElb: {
      Type: 'AWS::EC2::SecurityGroupIngress',
      Properties: {
        SourceSecurityGroupId: {
          'Fn::GetAtt': ['SecurityGroupVpn', 'GroupId'],
        },
        GroupId: { 'Fn::GetAtt': ['SecurityGroupElb', 'GroupId'] },
        FromPort: 22,
        ToPort: 22,
        IpProtocol: 'tcp',
      },
    },

    SecurityGroupIngressAsgEfs: {
      Type: 'AWS::EC2::SecurityGroupIngress',
      Properties: {
        SourceSecurityGroupId: {
          'Fn::GetAtt': ['SecurityGroupAsg', 'GroupId'],
        },
        GroupId: { 'Fn::GetAtt': ['SecurityGroupEfs', 'GroupId'] },
        FromPort: 2049,
        ToPort: 2049,
        IpProtocol: 'tcp',
      },
    },

    // Egress rules
    SecurityGroupEgressPlaygroundBastion: {
      Type: 'AWS::EC2::SecurityGroupEgress',
      Properties: {
        DestinationSecurityGroupId: {
          'Fn::GetAtt': ['SecurityGroupPlayground', 'GroupId'],
        },
        GroupId: { 'Fn::GetAtt': ['SecurityGroupBastion', 'GroupId'] },
        FromPort: 22,
        ToPort: 22,
        IpProtocol: 'tcp',
      },
    },
    SecurityGroupEgressPlaygroundVpn: {
      Type: 'AWS::EC2::SecurityGroupEgress',
      Properties: {
        DestinationSecurityGroupId: {
          'Fn::GetAtt': ['SecurityGroupPlayground', 'GroupId'],
        },
        GroupId: { 'Fn::GetAtt': ['SecurityGroupVpn', 'GroupId'] },
        FromPort: 22,
        ToPort: 22,
        IpProtocol: 'tcp',
      },
    },

    SecurityGroupEgressAsgElb: {
      Type: 'AWS::EC2::SecurityGroupEgress',
      Properties: {
        DestinationSecurityGroupId: {
          'Fn::GetAtt': ['SecurityGroupAsg', 'GroupId'],
        },
        GroupId: { 'Fn::GetAtt': ['SecurityGroupElb', 'GroupId'] },
        FromPort: 22,
        ToPort: 22,
        IpProtocol: 'tcp',
      },
    },

    SecurityGroupEgressBastionElb: {
      Type: 'AWS::EC2::SecurityGroupEgress',
      Properties: {
        DestinationSecurityGroupId: {
          'Fn::GetAtt': ['SecurityGroupBastion', 'GroupId'],
        },
        GroupId: { 'Fn::GetAtt': ['SecurityGroupElb', 'GroupId'] },
        FromPort: 22,
        ToPort: 22,
        IpProtocol: 'tcp',
      },
    },
    SecurityGroupEgressVpnElb: {
      Type: 'AWS::EC2::SecurityGroupEgress',
      Properties: {
        DestinationSecurityGroupId: {
          'Fn::GetAtt': ['SecurityGroupVpn', 'GroupId'],
        },
        GroupId: { 'Fn::GetAtt': ['SecurityGroupElb', 'GroupId'] },
        FromPort: 22,
        ToPort: 22,
        IpProtocol: 'tcp',
      },
    },
    SecurityGroupEgressAsgEfs: {
      Type: 'AWS::EC2::SecurityGroupEgress',
      Properties: {
        DestinationSecurityGroupId: {
          'Fn::GetAtt': ['SecurityGroupEfs', 'GroupId'],
        },
        GroupId: { 'Fn::GetAtt': ['SecurityGroupAsg', 'GroupId'] },
        FromPort: 2049,
        ToPort: 2049,
        IpProtocol: 'tcp',
      },
    },

  },

  Outputs: {

    SecurityGroupBastionId: {
      Value: { Ref: 'SecurityGroupBastion' },
      Export: {
        Name: { 'Fn::Sub': '${AWS::StackName}-SecurityGroupBastionId' },
      },
    },

    SecurityGroupVpnId: {
      Value: { Ref: 'SecurityGroupVpn' },
      Export: {
        Name: { 'Fn::Sub': '${AWS::StackName}-SecurityGroupVpnId' },
      },
    },

    SecurityGroupPlaygroundId: {
      Value: { Ref: 'SecurityGroupPlayground' },
      Export: {
        Name: { 'Fn::Sub': '${AWS::StackName}-SecurityGroupPlaygroundId' },
      },
    },

    SecurityGroupAsgId: {
      Value: { Ref: 'SecurityGroupAsg' },
      Export: {
        Name: { 'Fn::Sub': '${AWS::StackName}-SecurityGroupAsgId' },
      },
    },

    SecurityGroupElbId: {
      Value: { Ref: 'SecurityGroupElb' },
      Export: {
        Name: { 'Fn::Sub': '${AWS::StackName}-SecurityGroupElbId' },
      },
    },
    SecurityGroupEfsId: {
      Value: { Ref: 'SecurityGroupEfs' },
      Export: {
        Name: { 'Fn::Sub': '${AWS::StackName}-SecurityGroupEfsId' },
      },
    },


  },
}

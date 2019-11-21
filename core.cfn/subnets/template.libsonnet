local cidrRegex = @'^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\/([0-9]|[1-2][0-9]|3[0-2]))$';

{
  AWSTemplateFormatVersion: '2010-09-09',
  Description: 'Subnets Template',
  Parameters: {
    Namespace: {
      Type: 'String',
      Description: 'Project namespace for tags.',
    },
    VpcId: {
      Type: 'String',
      Description: 'VPC ID to add subnets to.',
    },
    SubnetPublicOneCidr: {
      Type: 'String',
      Description: 'Cidr range for the subnet.',
      AllowedPattern: cidrRegex,
    },
    SubnetPublicTwoCidr: {
      Type: 'String',
      Description: 'Cidr range for the subnet.',
      AllowedPattern: cidrRegex,
    },
    SubnetPrivateOneCidr: {
      Type: 'String',
      Description: 'Cidr range for the subnet.',
      AllowedPattern: cidrRegex,
    },
    SubnetPrivateTwoCidr: {
      Type: 'String',
      Description: 'Cidr range for the subnet.',
      AllowedPattern: cidrRegex,
    },
  },

  Resources: {
    // Public Subnet One
    SubnetPublicOne: {
      Type: 'AWS::EC2::Subnet',
      Properties: {
        VpcId: { Ref: 'VpcId' },
        CidrBlock: { Ref: 'SubnetPublicOneCidr' },
        MapPublicIpOnLaunch: true,
        AvailabilityZone: { 'Fn::Select': ['0', { 'Fn::GetAZs': '' }] },
        Tags: [{
          Key: 'Name',
          Value: {
            'Fn::Sub': '${Namespace}-subnet-public-one',
          },
        }],
      },
    },

    // Public Subnet Two
    SubnetPublicTwo: {
      Type: 'AWS::EC2::Subnet',
      Properties: {
        VpcId: { Ref: 'VpcId' },
        CidrBlock: { Ref: 'SubnetPublicTwoCidr' },
        AvailabilityZone: { 'Fn::Select': ['1', { 'Fn::GetAZs': '' }] },
        MapPublicIpOnLaunch: true,
        Tags: [{
          Key: 'Name',
          Value: {
            'Fn::Sub': '${Namespace}-subnet-public-two',
          },
        }],
      },
    },

    // Private Subnet One
    SubnetPrivateOne: {
      Type: 'AWS::EC2::Subnet',
      Properties: {
        VpcId: { Ref: 'VpcId' },
        AvailabilityZone: { 'Fn::Select': ['0', { 'Fn::GetAZs': '' }] },
        CidrBlock: { Ref: 'SubnetPrivateOneCidr' },
        Tags: [{
          Key: 'Name',
          Value: {
            'Fn::Sub': '${Namespace}-subnet-private-one',
          },
        }],
      },
    },

    // Private Subnet Two
    SubnetPrivateTwo: {
      Type: 'AWS::EC2::Subnet',
      Properties: {
        VpcId: { Ref: 'VpcId' },
        CidrBlock: { Ref: 'SubnetPrivateTwoCidr' },
        AvailabilityZone: { 'Fn::Select': ['1', { 'Fn::GetAZs': '' }] },
        Tags: [{
          Key: 'Name',
          Value: {
            'Fn::Sub': '${Namespace}-subnet-private-two',
          },
        }],
      },
    },
  },

  Outputs: {
    SubnetPublicOneId: {
      Value: { Ref: 'SubnetPublicOne' },
      Export: { Name: { 'Fn::Sub': '${AWS::StackName}-SubnetPublicOneId' } },
    },

    SubnetPublicTwoId: {
      Value: { Ref: 'SubnetPublicTwo' },
      Export: { Name: { 'Fn::Sub': '${AWS::StackName}-SubnetPublicTwoId' } },
    },

    SubnetPrivateOneId: {
      Value: { Ref: 'SubnetPrivateOne' },
      Export: { Name: { 'Fn::Sub': '${AWS::StackName}-SubnetPrivateOneId' } },
    },

    SubnetPrivateTwoId: {
      Value: { Ref: 'SubnetPrivateTwo' },
      Export: { Name: { 'Fn::Sub': '${AWS::StackName}-SubnetPrivateTwoId' } },
    },
  },
}

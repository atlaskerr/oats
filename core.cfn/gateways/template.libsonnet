{
  AWSTemplateFormatVersion: '2010-09-09',
  Description: '',
  Parameters: {
    Namespace: {
      Type: 'String',
      Description: 'Project namespace for tags.',
    },

    VpcId: {
      Type: 'String',
      Description: 'VPC ID to add subnets to.',
    },

    SubnetPublicOneId: {
      Type: 'String',
      Description: 'Subnet Public One ID.',
    },

    SubnetPublicTwoId: {
      Type: 'String',
      Description: 'Subnet Public Two ID.',
    },
  },

  Resources: {
    // Internet Gateway
    InternetGateway: {
      name:: 'InternetGateway',
      Type: 'AWS::EC2::InternetGateway',
      Properties: {
        Tags: [{
          Key: 'Name',
          Value: {
            'Fn::Sub': '${Namespace}-internet-gateway',
          },
        }],
      },
    },
    InternetGatewayAttachment: {
      Type: 'AWS::EC2::VPCGatewayAttachment',
      Properties: {
        InternetGatewayId: { Ref: 'InternetGateway' },
        VpcId: { Ref: 'VpcId' },
      },
    },

    // Elastic IPs for NAT gateways.
    NatOneEip: {
      Type: 'AWS::EC2::EIP',
      Properties: {
        Domain: 'vpc',
      },
    },

    NatTwoEip: {
      Type: 'AWS::EC2::EIP',
      Properties: {
        Domain: 'vpc',
      },
    },

    // NAT Gateway One
    NatGatewayOne: {
      Type: 'AWS::EC2::NatGateway',
      Properties: {
        AllocationId: { 'Fn::GetAtt': ['NatOneEip', 'AllocationId'] },
        SubnetId: { Ref: 'SubnetPublicOneId' },
        Tags: [{
          Key: 'Name',
          Value: {
            'Fn::Sub': '${Namespace}-nat-gateway-one',
          },
        }],
      },
    },

    // NAT Gateway Two
    NatGatewayTwo: {
      Type: 'AWS::EC2::NatGateway',
      Properties: {
        AllocationId: { 'Fn::GetAtt': ['NatTwoEip', 'AllocationId'] },
        SubnetId: { Ref: 'SubnetPublicTwoId' },
        Tags: [{
          Key: 'Name',
          Value: {
            'Fn::Sub': '${Namespace}-nat-gateway-two',
          },
        }],
      },
    },

  },

  Outputs: {
    InternetGatewayId: {
      Description: 'Internet Gateway ID.',
      Value: { Ref: 'InternetGateway' },
    },
    NatGatewayOneId: {
      Description: 'NAT Gateway One',
      Value: { Ref: 'NatGatewayOne' },
    },
    NatGatewayTwoId: {
      Description: 'NAT Gateway Two',
      Value: { Ref: 'NatGatewayTwo' },
    },
  },

}

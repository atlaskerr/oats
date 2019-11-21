{
  AWSTemplateFormatVersion: '2010-09-09',
  Description: 'Routes Template',
  Parameters: {
    Namespace: {
      Type: 'String',
      Description: 'Project namespace for tags.',
    },
    VpcId: {
      Type: 'String',
      Description: 'VPC ID to add tables and routes to.',
    },
    InternetGatewayId: {
      Type: 'String',
      Description: 'ID of the internet gateway to route traffic out of VPC.',
    },
    NatGatewayOneId: {
      Type: 'String',
      Description: 'ID of the NAT gateway to route traffic out of the VPC',
    },
    NatGatewayTwoId: {
      Type: 'String',
      Description: 'ID of the NAT gateway to route traffic out of the VPC',
    },
    SubnetPublicOneId: {
      Type: 'String',
      Description: 'ID for a public subnet in a unique availability zone.',
    },
    SubnetPublicTwoId: {
      Type: 'String',
      Description: 'ID for a public subnet in a unique availability zone.',
    },
    SubnetPrivateOneId: {
      Type: 'String',
      Description: 'ID for a private subnet in a unique availability zone.',
    },
    SubnetPrivateTwoId: {
      Type: 'String',
      Description: 'ID for a private subnet in a unique availability zone.',
    },
  },

  Resources: {
    // Route tables.
    RouteTablePublic: {
      Type: 'AWS::EC2::RouteTable',
      Properties: {
        VpcId: { Ref: 'VpcId' },
        Tags: [{
          Key: 'Name',
          Value: {
            'Fn::Sub': '${Namespace}-route-table-public',
          },
        }],
      },
    },
    RouteTablePrivateOne: {
      Type: 'AWS::EC2::RouteTable',
      Properties: {
        VpcId: { Ref: 'VpcId' },
        Tags: [{
          Key: 'Name',
          Value: {
            'Fn::Sub': '${Namespace}-route-table-private-one',
          },
        }],
      },
    },
    RouteTablePrivateTwo: {
      Type: 'AWS::EC2::RouteTable',
      Properties: {
        VpcId: { Ref: 'VpcId' },
        Tags: [{
          Key: 'Name',
          Value: {
            'Fn::Sub': '${Namespace}-route-table-private-two',
          },
        }],
      },
    },

    // Route table and subnet associations.
    AssociationPublicSubnetPublicOne: {
      Type: 'AWS::EC2::SubnetRouteTableAssociation',
      Properties: {
        RouteTableId: { Ref: 'RouteTablePublic' },
        SubnetId: { Ref: 'SubnetPublicOneId' },
      },
    },
    AssociationPublicSubnetPublicTwo: {
      Type: 'AWS::EC2::SubnetRouteTableAssociation',
      Properties: {
        RouteTableId: { Ref: 'RouteTablePublic' },
        SubnetId: { Ref: 'SubnetPublicTwoId' },
      },
    },
    AssociationPrivateSubnetPrivateOne: {
      Type: 'AWS::EC2::SubnetRouteTableAssociation',
      Properties: {
        RouteTableId: { Ref: 'RouteTablePrivateOne' },
        SubnetId: { Ref: 'SubnetPrivateOneId' },
      },
    },
    AssociationPrivateSubnetPrivateTwo: {
      Type: 'AWS::EC2::SubnetRouteTableAssociation',
      Properties: {
        RouteTableId: { Ref: 'RouteTablePrivateTwo' },
        SubnetId: { Ref: 'SubnetPrivateTwoId' },
      },
    },

    // Routes
    RouteInternetGateway: {
      Type: 'AWS::EC2::Route',
      Properties: {
        DestinationCidrBlock: '0.0.0.0/0',
        GatewayId: { Ref: 'InternetGatewayId' },
        RouteTableId: { Ref: 'RouteTablePublic' },
      },
    },
    RouteNatGatewayOne: {
      Type: 'AWS::EC2::Route',
      Properties: {
        DestinationCidrBlock: '0.0.0.0/0',
        RouteTableId: { Ref: 'RouteTablePrivateOne' },
        NatGatewayId: { Ref: 'NatGatewayOneId' },
      },
    },
    RouteNatGatewayTwo: {
      Type: 'AWS::EC2::Route',
      Properties: {
        DestinationCidrBlock: '0.0.0.0/0',
        RouteTableId: { Ref: 'RouteTablePrivateTwo' },
        NatGatewayId: { Ref: 'NatGatewayTwoId' },
      },
    },
  },

}

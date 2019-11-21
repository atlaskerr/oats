local amazonLinux = 'ami-0ff8a91507f77f867';

{
  AWSTemplateFormatVersion: '2010-09-09',
  Description: 'VPN Instance Template',
  Parameters: {
    SecurityGroupId: {
      Type: 'String',
    },
    SubnetId: {
      Type: 'String',
    },
  },
  Resources: {
    Instance: {
      Type: 'AWS::EC2::Instance',
      Properties: {
        InstanceType: 't3.micro',
        ImageId: amazonLinux,
        KeyName: 'akerr-lab-key',
        SubnetId: { Ref: 'SubnetId' },
        SecurityGroupIds: [{ Ref: 'SecurityGroupId' }],
      },
    },

    EIP: { Type: 'AWS::EC2::EIP', Properties: { Domain: 'vpc' } },

    EIPAssociation: {
      Type: 'AWS::EC2::EIPAssociation',
      Properties: {
        AllocationId: { 'Fn::GetAtt': ['EIP', 'AllocationId'] },
        InstanceId: { Ref: 'Instance' },
      },
    },

  },
}

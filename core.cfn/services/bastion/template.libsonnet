local amazonLinux = 'ami-0ff8a91507f77f867';

{
  AWSTemplateFormatVersion: '2010-09-09',
  Description: 'Bastion Instance Template',
  Parameters: {
    SecurityGroupId: {
      Description: 'Security group to attach to instance.',
      Type: 'String',
    },
    SubnetId: {
      Description: 'ID of the subnet to place the instance in.',
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

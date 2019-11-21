local amazonLinux = 'ami-0ff8a91507f77f867';

{
  AWSTemplateFormatVersion: '2010-09-09',
  Description: 'Internal Instance Template',
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
  },
}

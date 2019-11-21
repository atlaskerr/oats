{
  AWSTemplateFormatVersion: '2010-09-09',
  Description: 'VPC Template',
  Parameters: {
    Environment: {
      Description: 'A unique name to associate with the VPC for tagging purposes.',
      Type: 'String',
    },
    CidrBlock: {
      Description: 'Cidr block to use for the VPC.',
      Type: 'String',
      AllowedPattern: @'^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\/([0-9]|[1-2][0-9]|3[0-2]))$',
    },
  },
  Resources: {
    VPC: {
      Type: 'AWS::EC2::VPC',
      Properties: {
        CidrBlock: { Ref: 'CidrBlock' },
        EnableDnsSupport: true,
        EnableDnsHostnames: true,
        Tags: [{ Key: 'Name', Value: { 'Fn::Sub': 'vpc-${Environment}' } }],
      },
    },
  },
  Outputs: {
    VpcId: {
      Description: 'VPC ID.',
      Value: { Ref: 'VPC' },
      Export: {
        Name: { 'Fn::Sub': '${AWS::StackName}-VpcId' },
      },
    },
  },
}

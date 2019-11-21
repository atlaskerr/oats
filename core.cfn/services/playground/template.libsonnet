local amazonLinux = 'ami-0ff8a91507f77f867';

{
  AWSTemplateFormatVersion: '2010-09-09',
  Description: 'Internal Instance Template',
  Parameters: {

    SecurityGroupId: {
      Description: 'Security group to attach to instance.',
      Type: 'String',
    },

    SubnetId: {
      Description: 'ID of the subnet to place the instance in.',
      Type: 'String',
    },

    ZoneId: {
      Description: 'Route53 zone to add the service DNS records to.',
      Type: 'String',
    },

    DnsName: {
      Description: 'FQDN to use for the service',
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

    DnsRecord: {
      Type: 'AWS::Route53::RecordSet',
      Properties: {
        HostedZoneId: { Ref: 'ZoneId' },
        Name: { Ref: 'DnsName' },
        TTL: '300',
        Type: 'A',
        ResourceRecords: [{ 'Fn::GetAtt': ['Instance', 'PrivateIp'] }],
      },
    },

  },
}

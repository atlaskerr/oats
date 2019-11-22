local amazonLinux = 'ami-0ff8a91507f77f867';

{
  AWSTemplateFormatVersion: '2010-09-09',
  Description: 'Internal Instance Template',
  Parameters: {

    PlaygroundSecurityGroupId: {
      Description: 'Security group to attach to instance.',
      Type: 'String',
    },
    ElbSecurityGroupId: {
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
        SecurityGroupIds: [{ Ref: 'PlaygroundSecurityGroupId' }],
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

    LoadBalancer: {
      Type: 'AWS::ElasticLoadBalancing::LoadBalancer',
      Properties: {
        Subnets: [{ Ref: 'SubnetId' }],
        SecurityGroups: [{ Ref: 'ElbSecurityGroupId' }],
        Listeners: [{
          LoadBalancerPort: '22',
          Protocol: 'TCP',
          InstancePort: '22',
          InstanceProtocol: 'TCP',
        }],
        HealthCheck: {
          HealthyThreshold: '2',
          Interval: '15',
          Target: 'TCP:22',
          Timeout: '10',
          UnhealthyThreshold: '2',
        },
      },
    },

  },
}

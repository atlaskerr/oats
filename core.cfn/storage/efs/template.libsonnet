{
  AWSTemplateFormatVersion: '2010-09-09',
  Description: 'EFS Storage Template',
  Parameters: {

    Namespace: {
      Type: 'String',
      Description: 'Project namespace for tags.',
    },

    PlaygroundSubnetId: {
      Type: 'String',
      Description: 'ID of the subnet to add Playground EFS volume.',
    },

    PlaygroundFileSystemSecurityGroupId: {
      Type: 'String',
      Description: 'ID of the subnet to add Playground EFS volume.',
    },

    ZoneId: {
      Description: 'Route53 zone to add the service DNS records to.',
      Type: 'String',
    },

    PlaygroundFileSystemDnsName: {
      Description: 'FQDN to use for the efs volume',
      Type: 'String',
    },

  },
  Resources: {

    PlaygroundFileSystem: {
      Type: 'AWS::EFS::FileSystem',
      Properties: {
        PerformanceMode: 'generalPurpose',
        FileSystemTags: [{
          Key: 'Name',
          Value: { 'Fn::Sub': '${Namespace}-efs-playground' },
        }],
      },
    },

    PlaygroundFileSystemMountTarget: {
      Type: 'AWS::EFS::MountTarget',
      Properties: {
        FileSystemId: { Ref: 'PlaygroundFileSystem' },
        SubnetId: { Ref: 'PlaygroundSubnetId' },
        SecurityGroups: [{ Ref: 'PlaygroundFileSystemSecurityGroupId' }],
      },
    },

    DnsRecord: {
      Type: 'AWS::Route53::RecordSet',
      Properties: {
        HostedZoneId: { Ref: 'ZoneId' },
        Name: { Ref: 'PlaygroundFileSystemDnsName' },
        TTL: '300',
        Type: 'A',
        ResourceRecords: [{
          'Fn::GetAtt': [
            'PlaygroundFileSystemMountTarget',
            'IpAddress',
          ],
        }],
      },
    },


  },

  Outputs: {
    PlaygroundFileSystemDnsName: {
      Description: 'ID of the Playground EFS.',
      Value: { Ref: 'DnsRecord' },
    },
  },
}

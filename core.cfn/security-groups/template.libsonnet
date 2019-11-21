local bastion = import 'bastion.libsonnet';
local all = import 'instance.libsonnet';
local vpn = import 'vpn.libsonnet';

{
  AWSTemplateFormatVersion: '2010-09-09',
  Description: 'Security Groups Template',
  Parameters: {
    VpcId: {
      Description: 'VPC ID to add security groups to.',
      Type: 'String',
    },
  },
  Resources: {
    SecurityGroupBastion: bastion,
    SecurityGroupVpn: vpn,
    SecurityGroupAll: all,
  },
  Outputs: {
    SecurityGroupBastionId: {
      Value: { Ref: 'SecurityGroupBastion' },
      Export: {
        Name: { 'Fn::Sub': '${AWS::StackName}-SecurityGroupBastionId' },
      },
    },
    SecurityGroupVpnId: {
      Value: { Ref: 'SecurityGroupVpn' },
      Export: {
        Name: { 'Fn::Sub': '${AWS::StackName}-SecurityGroupVpnId' },
      },
    },
    SecurityGroupAllId: {
      Value: { Ref: 'SecurityGroupAll' },
      Export: {
        Name: { 'Fn::Sub': '${AWS::StackName}-SecurityGroupAllId' },
      },
    },
  },
 }

{
  AWSTemplateFormatVersion: '2010-09-09',
  Description: 'Internal Role',
  Resources: {

    Role: {
      Type: 'AWS::IAM::Role',
      Properties: {
        Description: 'IAM role internal instances.',
        RoleName: 'internal-role',
        AssumeRolePolicyDocument: import 'assume-role.policy.json',
        ManagedPolicyArns: ['arn:aws:iam::aws:policy/ReadOnlyAccess'],
      },
    },

  },
}

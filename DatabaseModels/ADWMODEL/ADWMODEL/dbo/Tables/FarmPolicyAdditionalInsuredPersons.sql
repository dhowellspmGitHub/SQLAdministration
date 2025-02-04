CREATE TABLE [dbo].[FarmPolicyAdditionalInsuredPersons] (
    [PolicyId]                   INT           NOT NULL,
    [AdditionalInsuredNbr]       INT           NOT NULL,
    [PolicyNbr]                  VARCHAR (16)  NOT NULL,
    [AdditionalInsuredPersonsNm] VARCHAR (50)  NULL,
    [UpdatedTmstmp]              DATETIME2 (7) NOT NULL,
    [UserUpdatedId]              CHAR (8)      NOT NULL,
    [LastActionCd]               CHAR (1)      NOT NULL,
    [SourceSystemCd]             CHAR (2)      NOT NULL,
    CONSTRAINT [PK_FarmPolicyAdditionalInsuredPersons] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [AdditionalInsuredNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FarmPolicyAdditionalInsuredPersons_FarmPolicy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[FarmPolicy] ([PolicyId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FarmPolicyAdditionalInsuredPersons_01]
    ON [dbo].[FarmPolicyAdditionalInsuredPersons]([PolicyId] ASC)
    ON [POLICYCI];


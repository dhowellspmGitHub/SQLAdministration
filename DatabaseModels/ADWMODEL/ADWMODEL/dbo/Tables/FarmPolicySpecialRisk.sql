CREATE TABLE [dbo].[FarmPolicySpecialRisk] (
    [PolicyId]                INT            NOT NULL,
    [FarmPolicySpecialRiskId] INT            NOT NULL,
    [PolicyNbr]               VARCHAR (16)   NOT NULL,
    [SpecialRiskDaysNbr]      INT            NULL,
    [SpecialRiskPremiumAmt]   DECIMAL (9, 2) NULL,
    [PatternCd]               VARCHAR (64)   NULL,
    [UpdatedTmstmp]           DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]           CHAR (8)       NOT NULL,
    [LastActionCd]            CHAR (1)       NOT NULL,
    [SourceSystemCd]          CHAR (2)       NOT NULL,
    CONSTRAINT [PK_FarmPolicySpecialRisk] PRIMARY KEY CLUSTERED ([FarmPolicySpecialRiskId] ASC, [PolicyId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FarmPolicySpecialRisk_FarmPolicy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[FarmPolicy] ([PolicyId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FarmPolicySpecialRisk_01]
    ON [dbo].[FarmPolicySpecialRisk]([PolicyId] ASC)
    ON [POLICYCI];


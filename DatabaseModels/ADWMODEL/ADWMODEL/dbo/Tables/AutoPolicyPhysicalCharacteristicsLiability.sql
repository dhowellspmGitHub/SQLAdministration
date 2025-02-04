CREATE TABLE [dbo].[AutoPolicyPhysicalCharacteristicsLiability] (
    [PolicyId]                INT           NOT NULL,
    [PhysicalCharLiabilityCd] CHAR (10)     NOT NULL,
    [DebitCreditPointsNbr]    INT           NULL,
    [LastActionCd]            CHAR (1)      NOT NULL,
    [PolicyNbr]               CHAR (16)     NOT NULL,
    [SourceSystemCd]          CHAR (2)      NOT NULL,
    [SourceSystemPatternCd]   VARCHAR (50)  NULL,
    [UpdatedTmstmp]           DATETIME2 (7) NOT NULL,
    [UserUpdatedId]           CHAR (8)      NOT NULL,
    CONSTRAINT [PK_AutoPolicyPhysicalCharacteristicsLiabiility] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [PhysicalCharLiabilityCd] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AutoPolicyPhysicalCharacteristicsLiability_AutoPolicy] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[AutoPolicy] ([PolicyId])
) ON [POLICYCD];


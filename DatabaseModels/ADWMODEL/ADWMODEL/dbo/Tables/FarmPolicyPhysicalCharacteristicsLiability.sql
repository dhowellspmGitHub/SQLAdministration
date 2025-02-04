CREATE TABLE [dbo].[FarmPolicyPhysicalCharacteristicsLiability] (
    [PolicyId]                INT           NOT NULL,
    [PhysicalCharLiabilityCd] CHAR (10)     NOT NULL,
    [PolicyNbr]               VARCHAR (16)  NOT NULL,
    [DebitCreditPointsNbr]    INT           NULL,
    [PhysicalCharCategoryCd]  CHAR (10)     NULL,
    [CreatedTmstmp]           DATETIME      NOT NULL,
    [UserCreatedId]           CHAR (8)      NOT NULL,
    [UpdatedTmstmp]           DATETIME2 (7) NOT NULL,
    [UserUpdatedId]           CHAR (8)      NOT NULL,
    [LastActionCd]            CHAR (1)      NOT NULL,
    [SourceSystemCd]          CHAR (2)      NOT NULL,
    CONSTRAINT [PK_FarmPolicyPhysicalCharacteristicsLiability] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [PhysicalCharLiabilityCd] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FarmPolicyPhysicalCharacteristicsLiability_FarmPolicy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[FarmPolicy] ([PolicyId])
) ON [POLICYCD];


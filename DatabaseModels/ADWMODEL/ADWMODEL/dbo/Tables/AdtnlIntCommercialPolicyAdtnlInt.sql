CREATE TABLE [dbo].[AdtnlIntCommercialPolicyAdtnlInt] (
    [AdditionalInterestId]         INT           NOT NULL,
    [CommercialPolicyAdditionalId] INT           NOT NULL,
    [PolicyId]                     INT           NOT NULL,
    [PolicyNbr]                    VARCHAR (16)  NOT NULL,
    [UpdatedTmstmp]                DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                CHAR (8)      NOT NULL,
    [LastActionCd]                 CHAR (1)      NOT NULL,
    [SourceSystemCd]               CHAR (2)      NOT NULL,
    CONSTRAINT [PK_AdtnlIntCommercialPolicyAdtnlInt] PRIMARY KEY CLUSTERED ([AdditionalInterestId] ASC, [CommercialPolicyAdditionalId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AdditionalInterestCommercialPolicyAdditionalInterest_AdditionalInterest_01] FOREIGN KEY ([AdditionalInterestId]) REFERENCES [dbo].[AdditionalInterest] ([AdditionalInterestId]),
    CONSTRAINT [FK_AdditionalInterestCommercialPolicyAdditionalInterest_CommercialPolicyAdditionalInterest_01] FOREIGN KEY ([CommercialPolicyAdditionalId]) REFERENCES [dbo].[CommercialPolicyAdditionalInterest] ([CommercialPolicyAdditionalId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_AdtnlIntCommercialPolicyAdtnlInt_01]
    ON [dbo].[AdtnlIntCommercialPolicyAdtnlInt]([CommercialPolicyAdditionalId] ASC)
    ON [POLICYCI];


GO
CREATE NONCLUSTERED INDEX [IX_AdtnlIntCommercialPolicyAdtnlInt_02]
    ON [dbo].[AdtnlIntCommercialPolicyAdtnlInt]([PolicyId] ASC)
    ON [POLICYCI];


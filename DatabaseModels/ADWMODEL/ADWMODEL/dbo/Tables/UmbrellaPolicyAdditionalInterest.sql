CREATE TABLE [dbo].[UmbrellaPolicyAdditionalInterest] (
    [UmbrellaPolicyAdditionalInterestId] INT           NOT NULL,
    [PolicyId]                           INT           NOT NULL,
    [PolicyNbr]                          VARCHAR (16)  NOT NULL,
    [ActiveMortgageeInd]                 BIT           NOT NULL,
    [MortgageeSequenceNbr]               CHAR (3)      NULL,
    [PCAdditionalInterestNbr]            CHAR (10)     NULL,
    [MortgageeLoanNbr]                   CHAR (15)     NULL,
    [InterestDesc]                       CHAR (30)     NULL,
    [ToTheAttentionOfNm]                 VARCHAR (50)  NULL,
    [EscrowInd]                          CHAR (1)      NULL,
    [TempAdditionalInterestId]           INT           NULL,
    [UpdatedTmstmp]                      DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                      CHAR (8)      NOT NULL,
    [LastActionCd]                       CHAR (1)      NOT NULL,
    [SourceSystemCd]                     CHAR (2)      NOT NULL,
    CONSTRAINT [PK_UmbrellaPolicyAdditionalInterest] PRIMARY KEY CLUSTERED ([UmbrellaPolicyAdditionalInterestId] ASC, [PolicyId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_UmbrellaPolicyAdditionalInterest_UmbrellaPolicy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[UmbrellaPolicy] ([PolicyId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_UmbrellaPolicyAdditionalInterest_01]
    ON [dbo].[UmbrellaPolicyAdditionalInterest]([PolicyId] ASC)
    ON [POLICYCI];


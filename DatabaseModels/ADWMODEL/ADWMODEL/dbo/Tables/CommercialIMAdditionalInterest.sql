CREATE TABLE [dbo].[CommercialIMAdditionalInterest] (
    [CommercialIMAdditionalInterestId] INT           NOT NULL,
    [PolicyId]                         INT           NULL,
    [IMPartCoverageTypeCd]             VARCHAR (50)  NULL,
    [PolicyNbr]                        VARCHAR (16)  NOT NULL,
    [MortgageeSequenceNbr]             CHAR (3)      NULL,
    [MortgageeLoanNbr]                 CHAR (35)     NULL,
    [PCAdditionalInterestNbr]          CHAR (10)     NULL,
    [InterestDesc]                     VARCHAR (255) NULL,
    [ToTheAttentionOfNm]               VARCHAR (50)  NULL,
    [EscrowInd]                        CHAR (1)      NULL,
    [CreatedTmstmp]                    DATETIME      NOT NULL,
    [UserCreatedId]                    CHAR (8)      NOT NULL,
    [UpdatedTmstmp]                    DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                    CHAR (8)      NOT NULL,
    [LastActionCd]                     CHAR (1)      NOT NULL,
    [SourceSystemCd]                   CHAR (2)      NOT NULL,
    CONSTRAINT [PK_CommercialIMAdditionalInterest] PRIMARY KEY CLUSTERED ([CommercialIMAdditionalInterestId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialIMAdditionalInterest_CommercialIM_01] FOREIGN KEY ([PolicyId], [IMPartCoverageTypeCd]) REFERENCES [dbo].[CommercialIM] ([PolicyId], [IMPartCoverageTypeCd])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialIMAdditonalInterest_01]
    ON [dbo].[CommercialIMAdditionalInterest]([PolicyId] ASC)
    ON [POLICYCI];


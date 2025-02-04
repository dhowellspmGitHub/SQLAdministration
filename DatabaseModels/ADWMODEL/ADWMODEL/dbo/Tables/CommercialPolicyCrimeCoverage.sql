CREATE TABLE [dbo].[CommercialPolicyCrimeCoverage] (
    [PolicyId]                INT             NOT NULL,
    [CoverageCd]              CHAR (3)        NOT NULL,
    [EndorsementId]           INT             NULL,
    [EndorsementNbr]          CHAR (10)       NULL,
    [PolicyNbr]               VARCHAR (16)    NOT NULL,
    [CoverageLimitAmt]        DECIMAL (9)     NULL,
    [CoveragePremiumAmt]      DECIMAL (9, 2)  NULL,
    [CoverageDeductibleAmt]   DECIMAL (5)     NULL,
    [SellingPriceAmt]         DECIMAL (9)     NULL,
    [SourceSystemCoverageCd]  VARCHAR (100)   NULL,
    [SellingPriceIncludedInd] CHAR (1)        NULL,
    [DeductibleAmt]           DECIMAL (18, 2) NULL,
    [CreatedTmstmp]           DATETIME        NOT NULL,
    [UserCreatedId]           CHAR (8)        NOT NULL,
    [UpdatedTmstmp]           DATETIME2 (7)   NOT NULL,
    [UserUpdatedId]           CHAR (8)        NOT NULL,
    [LastActionCd]            CHAR (1)        NOT NULL,
    [SourceSystemCd]          CHAR (2)        NOT NULL,
    CONSTRAINT [PK_CommercialPolicyCrimeCoverage] PRIMARY KEY CLUSTERED ([CoverageCd] ASC, [PolicyId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialCrimeCoverage_CommercialPolicy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[CommercialPolicy] ([PolicyId]),
    CONSTRAINT [FK_CommercialPolicyCrimeCoverage_Endorsements_01] FOREIGN KEY ([EndorsementId]) REFERENCES [dbo].[Endorsements] ([EndorsementId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialPolicyCrimeCoverage_01]
    ON [dbo].[CommercialPolicyCrimeCoverage]([PolicyId] ASC)
    ON [POLICYCI];


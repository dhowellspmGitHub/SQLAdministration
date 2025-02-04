CREATE TABLE [dbo].[CommercialQuoteCrimeCoverageDetail] (
    [QuoteNbr]                      VARCHAR (16)  NOT NULL,
    [CommercialPolicyCrimeDetailId] INT           NOT NULL,
    [CoverageCd]                    CHAR (3)      NOT NULL,
    [LocationID]                    BIGINT        NULL,
    [EndorsementId]                 INT           NULL,
    [PolicyAdditionalInsuredId]     BIGINT        NULL,
    [EndorsementNbr]                CHAR (10)     NULL,
    [CompanyOrClientNm]             VARCHAR (255) NULL,
    [SourceSystemCoverageCd]        VARCHAR (100) NULL,
    [CreatedTmstmp]                 DATETIME      NOT NULL,
    [UserCreatedId]                 CHAR (8)      NOT NULL,
    [UpdatedTmstmp]                 DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                 CHAR (8)      NOT NULL,
    [LastActionCd]                  CHAR (1)      NOT NULL,
    [SourceSystemCd]                CHAR (2)      NOT NULL,
    CONSTRAINT [PK_CommercialQuoteCrimeCoverageDetail] PRIMARY KEY CLUSTERED ([CommercialPolicyCrimeDetailId] ASC, [CoverageCd] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialQuoteCrimeCoverageDetail_CommercialQuoteCrimeCoverage_01] FOREIGN KEY ([CoverageCd], [QuoteNbr]) REFERENCES [dbo].[CommercialQuoteCrimeCoverage] ([CoverageCd], [QuoteNbr]),
    CONSTRAINT [FK_CommercialQuoteCrimeCoverageDetail_Location_01] FOREIGN KEY ([LocationID]) REFERENCES [dbo].[Location] ([LocationID])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialQuoteCrimeCoverageDetail_01]
    ON [dbo].[CommercialQuoteCrimeCoverageDetail]([QuoteNbr] ASC)
    ON [POLICYCI];


CREATE TABLE [dbo].[CommercialPolicyCrimeCoverageDetail] (
    [PolicyId]                      INT           NOT NULL,
    [CoverageCd]                    CHAR (3)      NOT NULL,
    [CommercialPolicyCrimeDetailId] INT           NOT NULL,
    [EndorsementId]                 INT           NULL,
    [LocationID]                    BIGINT        NULL,
    [PolicyAdditionalInsuredId]     BIGINT        NULL,
    [PolicyNbr]                     VARCHAR (16)  NOT NULL,
    [EndorsementNbr]                CHAR (10)     NULL,
    [CompanyOrClientNm]             VARCHAR (255) NULL,
    [SourceSystemCoverageCd]        VARCHAR (100) NULL,
    [CreatedTmstmp]                 DATETIME      NOT NULL,
    [UserCreatedId]                 CHAR (8)      NOT NULL,
    [UpdatedTmstmp]                 DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                 CHAR (8)      NOT NULL,
    [LastActionCd]                  CHAR (1)      NOT NULL,
    [SourceSystemCd]                CHAR (2)      NOT NULL,
    CONSTRAINT [PK_CommercialPolicyCrimeCoverageDetail] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [CoverageCd] ASC, [CommercialPolicyCrimeDetailId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialPolicyCrimeCoverageDetail_CommercialPolicyCrimeCoverage_01] FOREIGN KEY ([CoverageCd], [PolicyId]) REFERENCES [dbo].[CommercialPolicyCrimeCoverage] ([CoverageCd], [PolicyId]),
    CONSTRAINT [FK_CommercialPolicyCrimeCoverageDetail_Endorsements_01] FOREIGN KEY ([EndorsementId]) REFERENCES [dbo].[Endorsements] ([EndorsementId]),
    CONSTRAINT [FK_CommercialPolicyCrimeCoverageDetail_Location_01] FOREIGN KEY ([LocationID]) REFERENCES [dbo].[Location] ([LocationID]),
    CONSTRAINT [FK_CommercialPolicyCrimeCoverageDetail_PolicyAdditionalInsured_01] FOREIGN KEY ([PolicyAdditionalInsuredId]) REFERENCES [dbo].[PolicyAdditionalInsured] ([PolicyAdditionalInsuredId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialPolicyCrimeCoverageDetail_01]
    ON [dbo].[CommercialPolicyCrimeCoverageDetail]([PolicyId] ASC)
    ON [POLICYCI];


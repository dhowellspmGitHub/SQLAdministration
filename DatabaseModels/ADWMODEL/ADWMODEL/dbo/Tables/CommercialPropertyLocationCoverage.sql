CREATE TABLE [dbo].[CommercialPropertyLocationCoverage] (
    [PolicyId]           INT            NOT NULL,
    [CoverageCd]         CHAR (3)       NOT NULL,
    [LocationID]         BIGINT         NOT NULL,
    [PolicyNbr]          VARCHAR (16)   NOT NULL,
    [CoverageLimitAmt]   DECIMAL (9)    NULL,
    [CoveragePremiumAmt] DECIMAL (9, 2) NOT NULL,
    [CoverageDesc]       VARCHAR (250)  NOT NULL,
    [CreatedTmstmp]      DATETIME       NOT NULL,
    [UserCreatedId]      CHAR (8)       NOT NULL,
    [UpdatedTmstmp]      DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]      CHAR (8)       NOT NULL,
    [LastActionCd]       CHAR (1)       NOT NULL,
    [SourceSystemCd]     CHAR (2)       NOT NULL,
    CONSTRAINT [PK_CommercialPropertyLocationCoverage] PRIMARY KEY CLUSTERED ([CoverageCd] ASC, [PolicyId] ASC, [LocationID] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialPropertyLocationCoverage_PolicyLocationDetail_01] FOREIGN KEY ([PolicyId], [LocationID]) REFERENCES [dbo].[PolicyLocationDetail] ([PolicyId], [LocationID])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialPropertyLocationCoverage_01]
    ON [dbo].[CommercialPropertyLocationCoverage]([PolicyId] ASC)
    ON [POLICYCI];


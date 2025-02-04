CREATE TABLE [dbo].[FarmQuoteCoverageDetail] (
    [QuoteNbr]               VARCHAR (16)  NOT NULL,
    [CoverageCd]             CHAR (3)      NOT NULL,
    [NamedPersonsMedicalNbr] INT           NOT NULL,
    [NamedPersonsMedicalNm]  VARCHAR (50)  NULL,
    [BirthDt]                DATE          NULL,
    [CreatedTmstmp]          DATETIME      NOT NULL,
    [UserCreatedId]          CHAR (8)      NOT NULL,
    [UpdatedTmstmp]          DATETIME2 (7) NOT NULL,
    [UserUpdatedId]          CHAR (8)      NOT NULL,
    [LastActionCd]           CHAR (1)      NOT NULL,
    [SourceSystemCd]         CHAR (2)      NOT NULL,
    CONSTRAINT [PK_FarmQuoteCoverageDetail] PRIMARY KEY CLUSTERED ([NamedPersonsMedicalNbr] ASC, [CoverageCd] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FarmQuoteCoverageDetail_FarmQuoteCoverage_01] FOREIGN KEY ([CoverageCd], [QuoteNbr]) REFERENCES [dbo].[FarmQuoteCoverage] ([CoverageCd], [QuoteNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FarmQuoteCoverageDetail_01]
    ON [dbo].[FarmQuoteCoverageDetail]([QuoteNbr] ASC)
    ON [POLICYCI];


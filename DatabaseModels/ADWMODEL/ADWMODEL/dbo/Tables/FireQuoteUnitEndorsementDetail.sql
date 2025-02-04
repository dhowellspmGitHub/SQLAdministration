CREATE TABLE [dbo].[FireQuoteUnitEndorsementDetail] (
    [EndorsementUnitDetailId] INT           NOT NULL,
    [QuoteNbr]                VARCHAR (16)  NOT NULL,
    [EndorsementId]           INT           NOT NULL,
    [UnitNbr]                 INT           NOT NULL,
    [EndorsementNbr]          CHAR (10)     NOT NULL,
    [ItemNbr]                 CHAR (3)      NULL,
    [StructureDesc]           VARCHAR (255) NULL,
    [ShortDesc]               VARCHAR (255) NULL,
    [UpdatedTmstmp]           DATETIME2 (7) NOT NULL,
    [UserUpdatedId]           CHAR (8)      NOT NULL,
    [LastActionCd]            CHAR (1)      NOT NULL,
    [SourceSystemCd]          CHAR (2)      NOT NULL,
    CONSTRAINT [PK_FireQuoteUnitEndorsementDetail] PRIMARY KEY CLUSTERED ([EndorsementUnitDetailId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FireQuoteUnitEndorsementDetail_FireQuoteUnitEndorsement_01] FOREIGN KEY ([UnitNbr], [EndorsementId], [QuoteNbr]) REFERENCES [dbo].[FireQuoteUnitEndorsement] ([UnitNbr], [EndorsementId], [QuoteNbr])
) ON [POLICYCD];


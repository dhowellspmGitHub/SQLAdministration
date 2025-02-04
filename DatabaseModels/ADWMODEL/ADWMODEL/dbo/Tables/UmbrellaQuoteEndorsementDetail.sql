CREATE TABLE [dbo].[UmbrellaQuoteEndorsementDetail] (
    [EndorsementDetailId] INT           NOT NULL,
    [EndorsementId]       INT           NOT NULL,
    [QuoteNbr]            VARCHAR (16)  NOT NULL,
    [EndorsementNbr]      CHAR (10)     NOT NULL,
    [ItemNbr]             CHAR (3)      NOT NULL,
    [ArticleNbr]          CHAR (3)      NOT NULL,
    [LocationNameDesc]    VARCHAR (255) NULL,
    [ManufacturingYearDt] CHAR (4)      NULL,
    [MakeDesc]            VARCHAR (100) NULL,
    [ModelNm]             VARCHAR (100) NULL,
    [AddressDesc]         VARCHAR (100) NULL,
    [TrustMemberNm]       VARCHAR (255) NULL,
    [VehicleHullIDVINNbr] CHAR (17)     NULL,
    [UpdatedTmstmp]       DATETIME2 (7) NOT NULL,
    [UserUpdatedId]       CHAR (8)      NOT NULL,
    [LastActionCd]        CHAR (1)      NOT NULL,
    [SourceSystemCd]      CHAR (2)      NOT NULL,
    CONSTRAINT [PK_UmbrellaQuoteEndorsementDetail] PRIMARY KEY CLUSTERED ([EndorsementDetailId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_UmbrellaQuoteEndorsementDetail_UmbrellaQuoteEndorsement_01] FOREIGN KEY ([QuoteNbr], [EndorsementId]) REFERENCES [dbo].[UmbrellaQuoteEndorsement] ([QuoteNbr], [EndorsementId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_UmbrellaQuoteEndorsementDetail_01]
    ON [dbo].[UmbrellaQuoteEndorsementDetail]([QuoteNbr] ASC)
    ON [POLICYCI];


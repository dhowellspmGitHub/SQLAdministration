CREATE TABLE [dbo].[AutoQuoteGarageAddress] (
    [AutoQuoteGarageAddressId] INT           NOT NULL,
    [QuoteNbr]                 VARCHAR (16)  NOT NULL,
    [UnitNbr]                  INT           NOT NULL,
    [SublineBusinessTypeCd]    CHAR (1)      NOT NULL,
    [StreetAddressDesc]        VARCHAR (100) NULL,
    [CityNm]                   CHAR (30)     NULL,
    [CountyNbr]                CHAR (3)      NULL,
    [StateCd]                  CHAR (2)      NULL,
    [ZipCd]                    CHAR (9)      NULL,
    [LocationDescTxt]          VARCHAR (100) NULL,
    [UpdatedTmstmp]            DATETIME2 (7) NOT NULL,
    [UserUpdatedId]            CHAR (8)      NOT NULL,
    [LastActionCd]             CHAR (1)      NOT NULL,
    [SourceSystemCd]           CHAR (2)      NOT NULL,
    CONSTRAINT [PK_AutoQuoteGarageAddress] PRIMARY KEY CLUSTERED ([AutoQuoteGarageAddressId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AutoQuoteGarageAddress_AutoQuoteUnit_01] FOREIGN KEY ([QuoteNbr], [UnitNbr]) REFERENCES [dbo].[AutoQuoteUnit] ([QuoteNbr], [UnitNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_AutoQuoteGarageAddress_01]
    ON [dbo].[AutoQuoteGarageAddress]([QuoteNbr] ASC)
    ON [POLICYCI];


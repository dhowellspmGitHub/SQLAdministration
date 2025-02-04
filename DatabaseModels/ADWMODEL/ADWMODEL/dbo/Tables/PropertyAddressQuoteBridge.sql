CREATE TABLE [dbo].[PropertyAddressQuoteBridge] (
    [PropertyAddressId] INT           NOT NULL,
    [QuoteNbr]          VARCHAR (16)  NOT NULL,
    [LineofBusinessCd]  CHAR (2)      NOT NULL,
    [UpdatedTmstmp]     DATETIME2 (7) NOT NULL,
    [UserUpdatedId]     CHAR (8)      NOT NULL,
    [LastActionCd]      CHAR (1)      NOT NULL,
    [SourceSystemCd]    CHAR (2)      NOT NULL,
    CONSTRAINT [PK_PropertyAddressQuoteBridge] PRIMARY KEY CLUSTERED ([QuoteNbr] ASC, [PropertyAddressId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_PropertyAddressQuoteBridge_PropertyAddress_01] FOREIGN KEY ([PropertyAddressId]) REFERENCES [dbo].[PropertyAddress] ([PropertyAddressId]),
    CONSTRAINT [FK_PropertyAddressQuoteBridge_Quote_02] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[Quote] ([QuoteNbr])
) ON [CLAIMSCD];


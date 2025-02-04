CREATE TABLE [dbo].[QuoteLocationDetail] (
    [QuoteNbr]             VARCHAR (16)  NOT NULL,
    [LocationID]           BIGINT        NOT NULL,
    [CountyNbr]            CHAR (3)      NOT NULL,
    [TaxCd]                CHAR (4)      NOT NULL,
    [LocationTypeCd]       VARCHAR (50)  NOT NULL,
    [LocationNameDesc]     VARCHAR (255) NULL,
    [LocationDesc]         VARCHAR (255) NULL,
    [TaxJurisdictionNm]    CHAR (40)     NULL,
    [TerritoryCd]          CHAR (3)      NULL,
    [CreatedTmstmp]        DATETIME      NOT NULL,
    [UserCreatedId]        CHAR (8)      NOT NULL,
    [UpdatedTmstmp]        DATETIME2 (7) NOT NULL,
    [UserUpdatedId]        CHAR (8)      NOT NULL,
    [LastActionCd]         CHAR (1)      NOT NULL,
    [SourceSystemCd]       CHAR (2)      NOT NULL,
    [PrimaryLocationInd]   CHAR (1)      NULL,
    [PrimaryLocationIMInd] CHAR (1)      NULL,
    CONSTRAINT [PK_QuoteLocationDetail] PRIMARY KEY CLUSTERED ([QuoteNbr] ASC, [LocationID] ASC) ON [POLICYCD],
    CONSTRAINT [FK_QuoteLocationDetail_Location_01] FOREIGN KEY ([LocationID]) REFERENCES [dbo].[Location] ([LocationID]),
    CONSTRAINT [FK_QuoteLocationDetail_Quote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[Quote] ([QuoteNbr])
) ON [POLICYCD];


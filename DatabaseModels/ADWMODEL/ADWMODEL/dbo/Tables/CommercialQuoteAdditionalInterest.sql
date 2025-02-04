CREATE TABLE [dbo].[CommercialQuoteAdditionalInterest] (
    [CommercialQuoteAdditionalId] INT           NOT NULL,
    [QuoteNbr]                    VARCHAR (16)  NULL,
    [MortgageeSequenceNbr]        CHAR (3)      NULL,
    [MortgageeLoanNbr]            CHAR (35)     NULL,
    [PCAdditionalInterestNbr]     CHAR (10)     NULL,
    [InterestDesc]                VARCHAR (255) NULL,
    [ToTheAttentionOfNm]          VARCHAR (50)  NULL,
    [EscrowInd]                   CHAR (1)      NULL,
    [TempAdditionalInterestId]    INT           NULL,
    [ActiveMortgageeInd]          BIT           NULL,
    [EquipmentSerialNbr]          CHAR (20)     NULL,
    [LenderInd]                   CHAR (1)      NULL,
    [CreatedTmstmp]               DATETIME      NOT NULL,
    [UserCreatedId]               CHAR (8)      NOT NULL,
    [UpdatedTmstmp]               DATETIME2 (7) NOT NULL,
    [UserUpdatedId]               CHAR (8)      NOT NULL,
    [LastActionCd]                CHAR (1)      NOT NULL,
    [SourceSystemCd]              CHAR (2)      NOT NULL,
    CONSTRAINT [PK_CommercialQuoteAdditionalInterest] PRIMARY KEY CLUSTERED ([CommercialQuoteAdditionalId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialQuoteAdditionalInterest_CommercialQuote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[CommercialQuote] ([QuoteNbr])
) ON [POLICYCD];


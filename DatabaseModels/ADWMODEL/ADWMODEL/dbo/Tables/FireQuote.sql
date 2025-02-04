CREATE TABLE [dbo].[FireQuote] (
    [QuoteNbr]                    VARCHAR (16)  NOT NULL,
    [ComputerRatedLevelCd]        CHAR (1)      NULL,
    [CurrentCustomerInd]          CHAR (1)      NULL,
    [SurchargeExemptInd]          CHAR (1)      NULL,
    [ActiveAutoPolicyDiscountInd] CHAR (1)      NULL,
    [EQAddDt]                     DATE          NULL,
    [EQRemoveDt]                  DATE          NULL,
    [UpdatedTmstmp]               DATETIME2 (7) NOT NULL,
    [UserUpdatedId]               CHAR (8)      NOT NULL,
    [LastActionCd]                CHAR (1)      NOT NULL,
    [SourceSystemCd]              CHAR (2)      NOT NULL,
    CONSTRAINT [PK_FireQuote] PRIMARY KEY NONCLUSTERED ([QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FireQuote_Quote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[Quote] ([QuoteNbr])
) ON [POLICYCD];


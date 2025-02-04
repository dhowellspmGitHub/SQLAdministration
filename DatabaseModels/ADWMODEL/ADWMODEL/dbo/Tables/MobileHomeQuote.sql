CREATE TABLE [dbo].[MobileHomeQuote] (
    [QuoteNbr]                    VARCHAR (16)   NOT NULL,
    [ActiveAutoPolicyDiscountInd] CHAR (1)       NULL,
    [ReinsuranceCategoryCd]       CHAR (2)       NULL,
    [ComputerRatedLevelCd]        CHAR (1)       NULL,
    [CurrentCustomerInd]          CHAR (1)       NULL,
    [ClaimScoreCnt]               INT            NULL,
    [AlInsuranceCreditScoreCd]    CHAR (2)       NULL,
    [PropertyInsuranceScoreCnt]   INT            NULL,
    [SurchargeExemptInd]          CHAR (1)       NULL,
    [PropertyCreditScoreFctr]     DECIMAL (4, 3) NULL,
    [ActiveAutoFctr]              DECIMAL (4, 3) NULL,
    [ClaimScoreDt]                DATE           NULL,
    [UpdatedTmstmp]               DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]               CHAR (8)       NOT NULL,
    [LastActionCd]                CHAR (1)       NOT NULL,
    [SourceSystemCd]              CHAR (2)       NOT NULL,
    CONSTRAINT [PK_MobileHomeQuote] PRIMARY KEY CLUSTERED ([QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_MobileHomeQuote_Quote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[Quote] ([QuoteNbr])
) ON [POLICYCD];


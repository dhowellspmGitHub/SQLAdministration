CREATE TABLE [dbo].[HomeQuote] (
    [QuoteNbr]                    VARCHAR (16)   NOT NULL,
    [CurrentCustomerInd]          CHAR (1)       NULL,
    [ActiveAutoPolicyDiscountInd] CHAR (1)       NULL,
    [SurchargeExemptInd]          CHAR (1)       NULL,
    [ActiveAutoFctr]              DECIMAL (4, 3) NULL,
    [PropertyCreditScoreFctr]     DECIMAL (4, 3) NULL,
    [ReinsuranceCategoryCd]       CHAR (2)       NULL,
    [ComputerRatedLevelCd]        CHAR (1)       NULL,
    [InflationGuardCd]            CHAR (1)       NULL,
    [AlInsuranceCreditScoreCd]    CHAR (2)       NULL,
    [PropertyInsuranceScoreCnt]   INT            NULL,
    [ClaimScoreCnt]               INT            NULL,
    [AdditionalResidencesCnt]     INT            NULL,
    [ClaimScoreDt]                DATE           NULL,
    [UpdatedTmstmp]               DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]               CHAR (8)       NOT NULL,
    [LastActionCd]                CHAR (1)       NOT NULL,
    [SourceSystemCd]              CHAR (2)       NOT NULL,
    CONSTRAINT [PK_HomeQuote] PRIMARY KEY CLUSTERED ([QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_HomeQuote_Quote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[Quote] ([QuoteNbr])
) ON [POLICYCD];


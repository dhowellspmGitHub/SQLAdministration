CREATE TABLE [dbo].[QuoteViolation] (
    [AutoQuoteViolationId]        INT           NOT NULL,
    [QuoteNbr]                    VARCHAR (16)  NOT NULL,
    [UnitNbr]                     INT           NOT NULL,
    [QuotePartyRelationId]        INT           NOT NULL,
    [SublineBusinessTypeCd]       CHAR (1)      NOT NULL,
    [ViolationSequenceNbr]        INT           NULL,
    [ViolationCd]                 CHAR (2)      NULL,
    [ViolationDesc]               CHAR (50)     NULL,
    [ViolationDt]                 DATE          NULL,
    [ViolationChargeCd]           CHAR (2)      NULL,
    [ViolationOrigPointCnt]       CHAR (2)      NULL,
    [ViolationPointCnt]           INT           NULL,
    [ViolationAgedPointCnt]       CHAR (2)      NULL,
    [ViolationReceiptDt]          DATE          NULL,
    [ViolationChargedOnPolicyInd] CHAR (1)      NULL,
    [ConvictionDt]                DATE          NULL,
    [DriverNbr]                   CHAR (3)      NULL,
    [MVRSVCCd]                    CHAR (10)     NULL,
    [SurchargeExemptInd]          CHAR (1)      NULL,
    [UseInPlacementInd]           CHAR (1)      NULL,
    [OperatorNm]                  VARCHAR (50)  NULL,
    [AppliedPolicyNbr]            VARCHAR (16)  NULL,
    [InsertedTmstmp]              DATETIME2 (7) NOT NULL,
    [UpdatedTmstmp]               DATETIME2 (7) NOT NULL,
    [UserUpdatedId]               CHAR (8)      NOT NULL,
    [LastActionCd]                CHAR (1)      NOT NULL,
    [SourceSystemCd]              CHAR (2)      NOT NULL,
    CONSTRAINT [PK_QuoteViolation] PRIMARY KEY CLUSTERED ([AutoQuoteViolationId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AutoQuoteDriver_QuoteViolation_1] FOREIGN KEY ([QuoteNbr], [UnitNbr], [QuotePartyRelationId]) REFERENCES [dbo].[AutoQuoteDriver] ([QuoteNbr], [UnitNbr], [QuotePartyRelationId]),
    CONSTRAINT [FK_AutoQuoteUnit_QuoteViolation_1] FOREIGN KEY ([QuoteNbr], [UnitNbr]) REFERENCES [dbo].[AutoQuoteUnit] ([QuoteNbr], [UnitNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_QuoteViolation_01]
    ON [dbo].[QuoteViolation]([QuoteNbr] ASC)
    ON [POLICYCI];


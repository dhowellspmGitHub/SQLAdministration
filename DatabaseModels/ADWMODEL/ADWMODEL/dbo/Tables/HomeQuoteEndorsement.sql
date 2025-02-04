﻿CREATE TABLE [dbo].[HomeQuoteEndorsement] (
    [QuoteNbr]                           VARCHAR (16)   NOT NULL,
    [EndorsementId]                      INT            NOT NULL,
    [EndorsementNbr]                     CHAR (10)      NOT NULL,
    [EndorsementLimitAmt]                DECIMAL (9)    NULL,
    [EndorsementPremiumAmt]              DECIMAL (9, 2) NULL,
    [ChildrenCnt]                        CHAR (3)       NULL,
    [Days1to40EmployeeCnt]               INT            NULL,
    [Days1to40EmployeePremiumGrossAmt]   DECIMAL (9, 2) NULL,
    [Days41to179EmployeeCnt]             INT            NULL,
    [Days41to179EmployeePremiumGrossAmt] DECIMAL (9, 2) NULL,
    [FullTimeEmployeeCnt]                INT            NULL,
    [FullTimeEmployeePremiumGrossAmt]    DECIMAL (9, 2) NULL,
    [BusinessPursuitExceptionDesc]       VARCHAR (255)  NULL,
    [DwellingTypeDesc]                   VARCHAR (50)   NULL,
    [AlarmOrProtectionDiscountPct]       DECIMAL (5, 2) NULL,
    [UpdatedTmstmp]                      DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]                      CHAR (8)       NOT NULL,
    [LastActionCd]                       CHAR (1)       NOT NULL,
    [SourceSystemCd]                     CHAR (2)       NOT NULL,
    CONSTRAINT [PK_HomeQuoteEndorsement] PRIMARY KEY CLUSTERED ([QuoteNbr] ASC, [EndorsementId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_HomeQuoteEndorsement_Endorsements_01] FOREIGN KEY ([EndorsementId]) REFERENCES [dbo].[Endorsements] ([EndorsementId]),
    CONSTRAINT [FK_HomeQuoteEndorsement_HomeQuote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[HomeQuote] ([QuoteNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_HomeQuoteEndorsement_01]
    ON [dbo].[HomeQuoteEndorsement]([QuoteNbr] ASC)
    ON [POLICYCI];


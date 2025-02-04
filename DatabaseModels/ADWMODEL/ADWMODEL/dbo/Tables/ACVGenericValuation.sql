CREATE TABLE [dbo].[ACVGenericValuation] (
    [ACVGenericValuationId]     INT             NOT NULL,
    [ACVAmt]                    DECIMAL (18, 2) NULL,
    [CoveredItemTypeCd]         VARCHAR (10)    NULL,
    [DeductibleAmt]             DECIMAL (18, 2) NULL,
    [NonRecoverableDeprAmt]     DECIMAL (18, 2) NULL,
    [RCVAmt]                    DECIMAL (18, 2) NULL,
    [RecoverableDeprAmt]        DECIMAL (18, 2) NULL,
    [TaxAmt]                    DECIMAL (18, 2) NULL,
    [CurrentRecordInd]          BIT             NOT NULL,
    [RetiredInd]                CHAR (1)        NOT NULL,
    [SourceSystemId]            INT             NOT NULL,
    [SourceSystemCreatedTmstmp] DATETIME2 (7)   NOT NULL,
    [SourceSystemUserCreatedId] CHAR (10)       NOT NULL,
    [SourceSystemUpdatedTmstmp] DATETIME2 (7)   NOT NULL,
    [SourceSystemUserUpdatedId] CHAR (10)       NOT NULL,
    [UpdatedTmstmp]             DATETIME2 (7)   NOT NULL,
    [UserUpdatedId]             CHAR (8)        NOT NULL,
    [LastActionCd]              CHAR (1)        NOT NULL,
    [SourceSystemCd]            CHAR (2)        NOT NULL,
    CONSTRAINT [PK_ACVGenericValuation] PRIMARY KEY CLUSTERED ([ACVGenericValuationId] ASC) ON [CLAIMSCD]
) ON [CLAIMSCD];


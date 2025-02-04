CREATE TABLE [dbo].[ClaimReserveAmounts] (
    [ClaimAmountsId]            INT             NOT NULL,
    [ClaimNbr]                  CHAR (10)       NOT NULL,
    [OpenReservesAmt]           DECIMAL (18, 2) NULL,
    [OpenRecoveryReservesAmt]   DECIMAL (18, 2) NULL,
    [RemainingReservesAmt]      DECIMAL (18, 2) NULL,
    [AvailableReservesAmt]      DECIMAL (18, 2) NULL,
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
    CONSTRAINT [PK_ClaimReserveAmounts] PRIMARY KEY CLUSTERED ([ClaimAmountsId] ASC) ON [CLAIMSCD]
) ON [CLAIMSCD];


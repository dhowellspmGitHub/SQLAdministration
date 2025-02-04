CREATE TABLE [dbo].[MembershipEFTPaymentDetails] (
    [MembershipEFTPaymentDetailId] INT           NOT NULL,
    [MembershipNbr]                CHAR (10)     NOT NULL,
    [EffectiveDt]                  DATE          NOT NULL,
    [ExpirationDt]                 DATE          NULL,
    [EFTCancellationReasonCd]      CHAR (2)      NULL,
    [CurrentRecordInd]             BIT           NOT NULL,
    [SourceSystemUserCreatedId]    CHAR (10)     NOT NULL,
    [SourceSystemUserUpdatedId]    CHAR (10)     NOT NULL,
    [UpdatedTmstmp]                DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                CHAR (8)      NOT NULL,
    [SourceSystemCd]               CHAR (2)      NOT NULL,
    [LastActionCd]                 CHAR (1)      NOT NULL
);


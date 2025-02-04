CREATE TABLE [dbo].[MembershipEasyPayPaymentDetails] (
    [MembershipEFTPaymentDetailId] INT           NOT NULL,
    [MembershipId]                 INT           NOT NULL,
    [EBusinessId]                  VARCHAR (35)  NULL,
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
    [LastActionCd]                 CHAR (1)      NOT NULL,
    CONSTRAINT [PK_MembershipEasyPayPaymentDetails] PRIMARY KEY CLUSTERED ([MembershipEFTPaymentDetailId] ASC, [MembershipId] ASC) ON [MEMBERCD],
    CONSTRAINT [FK_MembershipEasyPayPaymentDetails_eBusinessProfile_01] FOREIGN KEY ([EBusinessId]) REFERENCES [dbo].[eBusinessProfile] ([EBusinessId]),
    CONSTRAINT [FK_MembershipEasyPayPaymentDetails_Membership_01] FOREIGN KEY ([MembershipId]) REFERENCES [dbo].[Membership] ([MembershipId])
) ON [MEMBERCD];


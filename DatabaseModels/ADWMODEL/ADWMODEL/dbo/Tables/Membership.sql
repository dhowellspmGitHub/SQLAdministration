CREATE TABLE [dbo].[Membership] (
    [MembershipId]                  INT           NOT NULL,
    [MembershipNbr]                 CHAR (10)     NOT NULL,
    [CurrentRecordInd]              BIT           NOT NULL,
    [CountyNbr]                     CHAR (3)      NULL,
    [MembershipStatusCd]            CHAR (1)      NULL,
    [EffectiveDt]                   DATE          NULL,
    [ExpirationDt]                  DATE          NULL,
    [MembershipPaidYearDt]          CHAR (4)      NULL,
    [PaymentProcessedDt]            DATE          NULL,
    [MembershipClassEffectiveDt]    DATE          NULL,
    [MembershipClassCd]             CHAR (3)      NULL,
    [PendingMembershipClassCd]      CHAR (3)      NULL,
    [FarmerDesignationCd]           CHAR (3)      NULL,
    [PendingFarmerDesignationCd]    CHAR (3)      NULL,
    [MembershipSuspensionCd]        CHAR (1)      NULL,
    [AOAPaymentInd]                 CHAR (1)      NULL,
    [MembershipPaymentInd]          CHAR (1)      NULL,
    [OriginalCountyNbr]             CHAR (3)      NULL,
    [OriginalInceptionDt]           DATE          NULL,
    [ChangeCountyNbr]               CHAR (3)      NULL,
    [ChangeCountyDt]                DATE          NULL,
    [LastTransactionDt]             DATE          NULL,
    [MembershipSystemUpdatedTmstmp] DATETIME2 (7) NULL,
    [MembershipSystemUserUpdatedId] CHAR (10)     NULL,
    [ArmsSystemUpdatedTmstmp]       DATETIME2 (7) NULL,
    [ArmsSystemUserUpdatedId]       CHAR (10)     NULL,
    [ArmsSystemCreatedTmstmp]       DATETIME2 (7) CONSTRAINT [DF_Membership_ArmsSystemCreatedTmstmp] DEFAULT (CONVERT([datetime2](7),'0001-01-01 00:00:00.0000000',(0))) NOT NULL,
    [ArmsSystemUserCreatedID]       CHAR (8)      CONSTRAINT [DF_Membership_ArmsSystemUserCreatedID] DEFAULT ('SYS') NOT NULL,
    [UpdatedTmstmp]                 DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                 CHAR (8)      NOT NULL,
    [LastActionCd]                  CHAR (1)      NOT NULL,
    [SourceSystemCd]                CHAR (2)      NOT NULL,
    CONSTRAINT [PK_Membership] PRIMARY KEY CLUSTERED ([MembershipId] ASC) ON [MEMBERCD]
) ON [MEMBERCD];


GO
CREATE NONCLUSTERED INDEX [IX_Membership_01]
    ON [dbo].[Membership]([MembershipNbr] ASC, [CurrentRecordInd] ASC)
    ON [MEMBERCI];


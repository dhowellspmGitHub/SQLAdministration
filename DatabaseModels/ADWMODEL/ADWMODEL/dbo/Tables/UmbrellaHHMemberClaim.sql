CREATE TABLE [dbo].[UmbrellaHHMemberClaim] (
    [SequenceNbr]        CHAR (3)       NOT NULL,
    [PolicyId]           INT            NOT NULL,
    [HouseholdMemberId]  INT            NOT NULL,
    [PolicyNbr]          VARCHAR (16)   NOT NULL,
    [BIPDPaidAmt]        DECIMAL (9, 2) NULL,
    [BIPDOutstandingAmt] DECIMAL (9, 2) NULL,
    [ClaimDesc]          VARCHAR (250)  NULL,
    [ClaimLossDt]        DATE           NULL,
    [NumberClaimantsCnt] INT            NULL,
    [TotalAmt]           DECIMAL (9, 2) NULL,
    [LossTypeDesc]       VARCHAR (255)  NULL,
    [CreatedTmstmp]      DATETIME       NOT NULL,
    [UserCreatedId]      CHAR (8)       NOT NULL,
    [UpdatedTmstmp]      DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]      CHAR (8)       NOT NULL,
    [LastActionCd]       CHAR (1)       NOT NULL,
    [SourceSystemCd]     CHAR (2)       NOT NULL,
    CONSTRAINT [PK_UmbrellaHHMemberClaim] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [HouseholdMemberId] ASC, [SequenceNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_UmbrellaHHMemberClaim_UmbrellaHHMember_01] FOREIGN KEY ([HouseholdMemberId]) REFERENCES [dbo].[UmbrellaHHMembers] ([HouseholdMemberId]),
    CONSTRAINT [FK_UmbrellaHHMemberClaim_UmbrellaHouseholdMembers] FOREIGN KEY ([HouseholdMemberId]) REFERENCES [dbo].[UmbrellaHHMembers] ([HouseholdMemberId]),
    CONSTRAINT [FK_UmbrellaPolicy_UmbrellaHHMemberClaim_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[UmbrellaPolicy] ([PolicyId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_UmbrellaHHMemberClaim_01]
    ON [dbo].[UmbrellaHHMemberClaim]([PolicyId] ASC)
    ON [POLICYCI];


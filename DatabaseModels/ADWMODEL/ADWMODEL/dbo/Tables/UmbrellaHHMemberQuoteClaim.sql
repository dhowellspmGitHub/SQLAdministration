CREATE TABLE [dbo].[UmbrellaHHMemberQuoteClaim] (
    [SequenceNbr]        CHAR (3)       NOT NULL,
    [QuoteNbr]           VARCHAR (16)   NOT NULL,
    [HouseholdMemberId]  INT            NOT NULL,
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
    CONSTRAINT [PK_UmbrellaHHMemberQuoteClaim] PRIMARY KEY CLUSTERED ([QuoteNbr] ASC, [HouseholdMemberId] ASC, [SequenceNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_UmbrellaHHMemberQuoteClaim_Quote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[Quote] ([QuoteNbr]),
    CONSTRAINT [FK_UmbrellaHHMemberQuoteClaim_UmbrellaQuoteHHMembers_01] FOREIGN KEY ([HouseholdMemberId]) REFERENCES [dbo].[UmbrellaQuoteHHMembers] ([HouseholdMemberId]),
    CONSTRAINT [FK_UmbrellaQuote_UmbrellaHHMemberQuoteClaim_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[UmbrellaQuote] ([QuoteNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_UmbrellaHHMemberQuoteClaim_01]
    ON [dbo].[UmbrellaHHMemberQuoteClaim]([QuoteNbr] ASC)
    ON [POLICYCI];


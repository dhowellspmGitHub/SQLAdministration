CREATE TABLE [dbo].[UmbrellaQuoteHHMembers] (
    [HouseholdMemberId]         INT           NOT NULL,
    [QuoteNbr]                  VARCHAR (16)  NOT NULL,
    [BirthDt]                   DATE          NULL,
    [FirstNm]                   CHAR (20)     NULL,
    [LastNm]                    CHAR (70)     NULL,
    [MembershipNbr]             CHAR (10)     NULL,
    [MaritalStatusCd]           CHAR (1)      NULL,
    [OccupationDesc]            VARCHAR (60)  NULL,
    [PrimaryNamedInsuredInd]    CHAR (1)      NULL,
    [FullOrParttimeStudentInd]  CHAR (1)      NULL,
    [GenderCd]                  CHAR (1)      NULL,
    [YouthfulDriverOverrideInd] CHAR (1)      NULL,
    [CreatedTmstmp]             DATETIME      NOT NULL,
    [UserCreatedId]             CHAR (8)      NOT NULL,
    [UpdatedTmstmp]             DATETIME2 (7) NOT NULL,
    [UserUpdatedId]             CHAR (8)      NOT NULL,
    [LastActionCd]              CHAR (1)      NOT NULL,
    [SourceSystemCd]            CHAR (2)      NOT NULL,
    CONSTRAINT [PK_UmbrellaQuoteHHMembers] PRIMARY KEY CLUSTERED ([HouseholdMemberId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_UmbrellaQuoteHHMembers_UmbrellaQuote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[UmbrellaQuote] ([QuoteNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_UmbrellaQuoteHHMembers_01]
    ON [dbo].[UmbrellaQuoteHHMembers]([QuoteNbr] ASC)
    ON [POLICYCI];


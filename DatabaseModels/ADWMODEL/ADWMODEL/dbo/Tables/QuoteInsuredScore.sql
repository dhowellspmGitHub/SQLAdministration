CREATE TABLE [dbo].[QuoteInsuredScore] (
    [QuoteNbr]                VARCHAR (16)  NOT NULL,
    [PartyId]                 INT           NOT NULL,
    [InsuranceScorePartyNbr]  CHAR (10)     NOT NULL,
    [RelationShipCd]          CHAR (2)      NULL,
    [RelationshipDesc]        VARCHAR (50)  NULL,
    [InsuredFirstNm]          VARCHAR (20)  NULL,
    [InsuredMiddleNm]         VARCHAR (20)  NULL,
    [InsuredLastNm]           VARCHAR (70)  NULL,
    [InsuranceScoreNbr]       DECIMAL (5)   NULL,
    [CurrentInsuranceScoreDt] DATE          NULL,
    [BestInsuranceScoreDt]    DATE          NULL,
    [BestInsuranceScoreNbr]   DECIMAL (5)   NULL,
    [UserCreatedId]           CHAR (8)      NOT NULL,
    [UserUpdatedId]           CHAR (8)      NOT NULL,
    [LastActionCd]            CHAR (1)      NOT NULL,
    [CreatedTmstmp]           DATETIME2 (7) NOT NULL,
    [UpdatedTmstmp]           DATETIME2 (7) NOT NULL,
    [SourceSystemCd]          CHAR (2)      NOT NULL,
    CONSTRAINT [PK_QuoteInsuredScore] PRIMARY KEY CLUSTERED ([QuoteNbr] ASC, [PartyId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_Party_QuoteInsuredScore_01] FOREIGN KEY ([PartyId]) REFERENCES [dbo].[Party] ([PartyId]),
    CONSTRAINT [FK_Quote_QuoteInsuredScore_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[Quote] ([QuoteNbr])
) ON [POLICYCD];


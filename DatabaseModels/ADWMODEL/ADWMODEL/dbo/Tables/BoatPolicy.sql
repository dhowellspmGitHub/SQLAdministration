CREATE TABLE [dbo].[BoatPolicy] (
    [PolicyId]             INT           NOT NULL,
    [PolicyNbr]            VARCHAR (16)  NOT NULL,
    [ComputerRatedLevelCd] CHAR (1)      NULL,
    [PicturesSubmittedInd] CHAR (1)      NULL,
    [LossesSinceLapseCnt]  INT           NULL,
    [UserUpdatedId]        CHAR (8)      NOT NULL,
    [UpdatedTmstmp]        DATETIME2 (7) NOT NULL,
    [LastActionCd]         CHAR (1)      NOT NULL,
    [SourceSystemCd]       CHAR (2)      NOT NULL,
    CONSTRAINT [PK_BoatPolicy] PRIMARY KEY CLUSTERED ([PolicyId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_BoatPolicy_Policy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[Policy] ([PolicyId])
) ON [POLICYCD];


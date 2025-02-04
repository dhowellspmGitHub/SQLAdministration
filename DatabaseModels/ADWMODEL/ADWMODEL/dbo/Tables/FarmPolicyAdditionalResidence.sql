CREATE TABLE [dbo].[FarmPolicyAdditionalResidence] (
    [PolicyId]               INT           NOT NULL,
    [AdditionalResidenceNbr] INT           NOT NULL,
    [PolicyNbr]              VARCHAR (16)  NOT NULL,
    [FarmAcresCnt]           DECIMAL (5)   NOT NULL,
    [CountyNbr]              CHAR (3)      NULL,
    [FarmDirectionCd]        CHAR (2)      NULL,
    [MilesFromTownNbr]       INT           NULL,
    [FarmTownRoadNm]         VARCHAR (60)  NULL,
    [FarmOwnerCd]            CHAR (1)      NULL,
    [UpdatedTmstmp]          DATETIME2 (7) NOT NULL,
    [UserUpdatedId]          CHAR (8)      NOT NULL,
    [LastActionCd]           CHAR (1)      NOT NULL,
    [SourceSystemCd]         CHAR (2)      NOT NULL,
    CONSTRAINT [PK_FarmPolicyAdditionalResidence] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [AdditionalResidenceNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FarmPolicyAdditionalResidence_FarmPolicy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[FarmPolicy] ([PolicyId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FarmPolicyAdditionalResidence_01]
    ON [dbo].[FarmPolicyAdditionalResidence]([PolicyId] ASC)
    ON [POLICYCI];

